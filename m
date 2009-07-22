From: Edward Shishkin <edward@redhat.com>
Subject: grub-0.97/VFS
Date: Wed, 22 Jul 2009 18:04:00 +0200
Message-ID: <4A673870.4060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, grub-devel@gnu.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone.

Grub-0.97 filesystem interface (read_func, dir_func)
seems to be poor. Instead of this I would prefer to
have something like the following:

/*
 *
 * .init_root()           // set index of root dir
 * .lookup_begin()        // get index by name
 * .lookup_end()          // get inode by index
 * .read_file()
 * .read_dir()
 * .read_symlink()
 *
 * so that dir_func in grub_open will look like the
 * following:
 */
int path_walk()
{
    ops->init_root();
    while (1) {
        int mode;
        ops->lookup_end(&mode, ...);

        switch (type_of_file(mode)) {
        case SYMLINK_FILE:
            follow_symlink(read_symlink, ...);
            ...;
            continue;
        case REGULAR_FILE:
            /*
             * the end of path walk:
             * normally we want to exit here
             */
            ...;
            return 1;
        case DIRECTORY_FILE:
            /*
             * optionally this will
             * print possibilities
             */
            ops->lookup_begin(mode, read_dir, ...);
            ...;
            continue;
        default:
            errnum = ERR_BAD_FILETYPE;
            return 0;
        }
    }
}

Just my 2 cents in the (grub-2?) development process..

Thanks,
Edward.

