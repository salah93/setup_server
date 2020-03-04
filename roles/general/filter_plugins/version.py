def version_minor(version_str):
    """Parses a version string of type major.minor.patch.more and returns
    a string like "major.minor"
    Intentionally not fully correct to avoid 3rd party imports"""
    return '.'.join(version_str.split('.')[:2])


def version_major(version_str):
    """Parses a version string of type major.minor.patch.more and returns
    a string like "major"
    Intentionally not fully correct to avoid 3rd party imports"""
    return version_str.split('.')[0]



class FilterModule(object):
    ''' Ansible core jinja2 filters '''

    def filters(self):
        return {
            'version_minor': version_minor,
            'version_major': version_major,
        }
