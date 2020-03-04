def version_minor(version_str):
    return '.'.join(version_str.split('.')[:2])


class FilterModule(object):
    def filters(self):
        return {
            'version_minor': version_minor,
        }
