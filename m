Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaINWra (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Sep 2014 18:47:30 -0400
Message-ID: <54161AFD.3070604@suse.com>
Date: Sun, 14 Sep 2014 18:47:25 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: canonicalize pathnames for device commands
References: <538F84DF.3090300@suse.com> <5413F2D0.3020006@oracle.com>
In-Reply-To: <5413F2D0.3020006@oracle.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/13/14, 3:31 AM, Anand Jain wrote:
> 
> 
> Jeff,
> 
> Nice patch. However its better if we do this in the btrfs kernel 
> function btrfs_scan_one_device(). Since the non-canonicalize path 
> can still sneak through the btrfs specific mount option "device=".
> 
> Any comments ?

My initial reaction is to avoid playing naming names within the
kernel. But since it's device mapper-specific, it might not be too
messy to do that. In addition to the patch to the progs, we're also
carrying a patch to systemd since it has it's own little ioctl wrapper
to do the scanning. It needed to be fixed there as well.

- -Jeff


> Thanks, Anand
> 
> 
> 
> On 06/05/2014 04:43 AM, Jeff Mahoney wrote:
>> mount(8) will canonicalize pathnames before passing them to the
>> kernel. Links to e.g. /dev/sda will be resolved to /dev/sda.
>> Links to /dev/dm-# will be resolved using the name of the device
>> mapper table to /dev/mapper/<name>.
>> 
>> Btrfs will use whatever name the user passes to it, regardless of
>> whether it is canonical or not. That means that if a 'btrfs
>> device ready' is issued on any device node pointing to the
>> original device, it will adopt the new name instead of the name
>> that was used during mount.
>> 
>> Mounting using /dev/sdb2 will result in df: /dev/sdb2
>> 209715200 39328 207577088   1% /mnt
>> 
>> # ls -la /dev/whatever-i-like lrwxrwxrwx 1 root root 4 Jun  4
>> 13:36 /dev/whatever-i-like -> sdb2 # btrfs dev ready
>> /dev/whatever-i-like # df /mnt /dev/whatever-i-like 209715200
>> 39328 207577088   1% /mnt
>> 
>> Likewise, mounting with /dev/mapper/whatever and using /dev/dm-0
>> with a btrfs device command results in df showing /dev/dm-0. This
>> can happen with multipath devices with friendly names enabled and
>> doing something like 'partprobe' which (at least with our
>> version) ends up issuing a 'change' uevent on the sysfs node.
>> That *always* uses the dm-# name, and we get confused users.
>> 
>> This patch does the same canonicalization of the paths that mount
>> does so that we don't end up having inconsistent names reported
>> by ->show_devices later.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- cmds-device.c  |
>> 60 ++++++++++++++++++++++++++++++++++++++++++++------------- 
>> cmds-replace.c |   13 ++++++++++-- utils.c        |   57 
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++ utils.h
>> |    2 + 4 files changed, 117 insertions(+), 15 deletions(-)
>> 
>> --- a/cmds-device.c +++ b/cmds-device.c @@ -95,6 +95,7 @@ static
>> int cmd_add_dev(int argc, char ** int    devfd, res; u64
>> dev_block_count = 0; int mixed = 0; +        char *path;
>> 
>> res = test_dev_for_mkfs(argv[i], force, estr); if (res) { @@
>> -118,15 +119,24 @@ static int cmd_add_dev(int argc, char ** goto
>> error_out; }
>> 
>> -        strncpy_null(ioctl_args.name, argv[i]); +        path =
>> canonicalize_path(argv[i]); +        if (!path) { +
>> fprintf(stderr, +                "ERROR: Could not canonicalize
>> pathname '%s': %s\n", +                argv[i],
>> strerror(errno)); +            ret++; +            goto
>> error_out; +        } + +        strncpy_null(ioctl_args.name,
>> path); res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args); e =
>> errno; -        if(res<0){ +        if (res < 0) { 
>> fprintf(stderr, "ERROR: error adding the device '%s' - %s\n", -
>> argv[i], strerror(e)); +                path, strerror(e)); 
>> ret++; } - +        free(path); }
>> 
>> error_out: @@ -242,6 +252,7 @@ static int cmd_scan_dev(int argc,
>> char *
>> 
>> for( i = devstart ; i < argc ; i++ ){ struct btrfs_ioctl_vol_args
>> args; +        char *path;
>> 
>> if (!is_block_device(argv[i])) { fprintf(stderr, @@ -249,9
>> +260,17 @@ static int cmd_scan_dev(int argc, char * ret = 1; goto
>> close_out; } -        printf("Scanning for Btrfs filesystems in
>> '%s'\n", argv[i]); +        path = canonicalize_path(argv[i]); +
>> if (!path) { +            fprintf(stderr, +
>> "ERROR: Could not canonicalize path '%s': %s\n", +
>> argv[i], strerror(errno)); +            ret = 1; +
>> goto close_out; +        } +        printf("Scanning for Btrfs
>> filesystems in '%s'\n", path);
>> 
>> -        strncpy_null(args.name, argv[i]); +
>> strncpy_null(args.name, path); /* * FIXME: which are the error
>> code returned by this ioctl ? * it seems that is impossible to
>> understand if there no is @@ -262,9 +281,11 @@ static int
>> cmd_scan_dev(int argc, char *
>> 
>> if( ret < 0 ){ fprintf(stderr, "ERROR: unable to scan the device
>> '%s' - %s\n", -                argv[i], strerror(e)); +
>> path, strerror(e)); +            free(path); goto close_out; } +
>> free(path); }
>> 
>> close_out: @@ -284,6 +305,7 @@ static int cmd_ready_dev(int argc,
>> char struct    btrfs_ioctl_vol_args args; int    fd; int    ret; 
>> +    char    *path;
>> 
>> if (check_argc_min(argc, 2)) usage(cmd_ready_dev_usage); @@
>> -293,22 +315,34 @@ static int cmd_ready_dev(int argc, char 
>> perror("failed to open /dev/btrfs-control"); return 1; } -    if
>> (!is_block_device(argv[1])) { + +    path =
>> canonicalize_path(argv[argc - 1]); +    if (!path) { 
>> fprintf(stderr, -            "ERROR: %s is not a block device\n",
>> argv[1]); -        close(fd); -        return 1; +
>> "ERROR: Could not canonicalize pathname '%s': %s\n", +
>> argv[argc - 1], strerror(errno)); +        ret = 1; +        goto
>> out; }
>> 
>> -    strncpy(args.name, argv[argc - 1], BTRFS_PATH_NAME_MAX); +
>> if (!is_block_device(path)) { +        fprintf(stderr, +
>> "ERROR: %s is not a block device\n", path); +        ret = 1; +
>> goto out; +    } + +    strncpy(args.name, path,
>> BTRFS_PATH_NAME_MAX); ret = ioctl(fd, BTRFS_IOC_DEVICES_READY,
>> &args); if (ret < 0) { fprintf(stderr, "ERROR: unable to
>> determine if the device '%s'" -            " is ready for
>> mounting - %s\n", argv[argc - 1], +            " is ready for
>> mounting - %s\n", path, strerror(errno)); ret = 1; }
>> 
>> +out: +    free(path); close(fd); return ret; } ---
>> a/cmds-replace.c +++ b/cmds-replace.c @@ -134,7 +134,7 @@ static
>> int cmd_start_replace(int argc, c int fddstdev = -1; char *path; 
>> char *srcdev; -    char *dstdev; +    char *dstdev = NULL; int
>> avoid_reading_from_srcdev = 0; int force_using_targetdev = 0; 
>> struct stat st; @@ -204,7 +204,12 @@ static int
>> cmd_start_replace(int argc, c }
>> 
>> srcdev = argv[optind]; -    dstdev = argv[optind + 1]; +
>> dstdev = canonicalize_path(argv[optind + 1]); +    if (!dstdev)
>> { +        fprintf(stderr, +            "ERROR: Could not
>> canonicalize path '%s': %s\n", +            argv[optind + 1],
>> strerror(errno)); +    }
>> 
>> if (is_numerical(srcdev)) { struct btrfs_ioctl_fs_info_args
>> fi_args; @@ -278,6 +283,8 @@ static int cmd_start_replace(int
>> argc, c
>> 
>> close(fddstdev); fddstdev = -1; +    free(dstdev); +    dstdev =
>> NULL;
>> 
>> dev_replace_handle_sigint(fdmnt); if (!do_not_background) { @@
>> -312,6 +319,8 @@ static int cmd_start_replace(int argc, c return
>> 0;
>> 
>> leave_with_error: +    if (dstdev) +        free(dstdev); if
>> (fdmnt != -1) close(fdmnt); if (fdsrcdev != -1) --- a/utils.c +++
>> b/utils.c @@ -987,6 +987,63 @@ static int
>> blk_file_in_dev_list(struct b }
>> 
>> /* + * Resolve a pathname to a device mapper node to
>> /dev/mapper/<name> + * Returns NULL on invalid input or malloc
>> failure; Other failures + * will be handled by the caller using
>> the input pathame. + */ +char *canonicalize_dm_name(const char
>> *ptname) +{ +    FILE    *f; +    size_t    sz; +    char
>> path[256], name[256], *res = NULL; + +    if (!ptname ||
>> !*ptname) +        return NULL; + +    snprintf(path,
>> sizeof(path), "/sys/block/%s/dm/name", ptname); +    if (!(f =
>> fopen(path, "r"))) +        return NULL; + +    /* read <name>\n
>> from sysfs */ +    if (fgets(name, sizeof(name), f) && (sz =
>> strlen(name)) > 1) { +        name[sz - 1] = '\0'; +
>> snprintf(path, sizeof(path), "/dev/mapper/%s", name); + +
>> if (access(path, F_OK) == 0) +            res = strdup(path); +
>> } +    fclose(f); +    return res; +} + +/* + * Resolve a
>> pathname to a canonical device node, e.g. /dev/sda1 or + * to a
>> device mapper pathname. + * Returns NULL on invalid input or
>> malloc failure; Other failures + * will be handled by the caller
>> using the input pathame. + */ +char *canonicalize_path(const char
>> *path) +{ +    char *canonical, *p; + +    if (!path || !*path) +
>> return NULL; + +    canonical = realpath(path, NULL); +    if
>> (!canonical) +        return strdup(path); +    p =
>> strrchr(canonical, '/'); +    if (p && strncmp(p, "/dm-", 4) == 0
>> && isdigit(*(p + 4))) { +        char *dm =
>> canonicalize_dm_name(p + 1); +        if (dm) { +
>> free(canonical); +            return dm; +        } +    } +
>> return canonical; +} + +/* * returns 1 if the device was mounted,
>> < 0 on error or 0 if everything * is safe to continue. */ ---
>> a/utils.h +++ b/utils.h @@ -61,6 +61,8 @@ int
>> btrfs_add_to_fsid(struct btrfs_trans int btrfs_scan_for_fsid(int
>> run_ioctls); void btrfs_register_one_device(char *fname); int
>> btrfs_scan_one_dir(char *dirname, int run_ioctl); +char
>> *canonicalize_dm_name(const char *ptname); +char
>> *canonicalize_path(const char *path); int check_mounted(const
>> char *devicename); int check_mounted_where(int fd, const char
>> *file, char *where, int size, struct btrfs_fs_devices
>> **fs_devices_mnt);
>> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJUFhr9AAoJEB57S2MheeWyXzgQAMKR0b29uU0kyYbalOxjpVkB
yAvR5kFItcEgRSfUUyqJqL+atJZ2PrzU4fQsz6i25cOBfQC5EdZYO/QENXe7HleU
oCECYucZC14qTLwswhpMeCtyMrX98sjhQxZ6NPSmLZWi/Btc2QDdwwbij4B3KRnQ
lE/AWmtT/J0fqlmjr18ETdTjTCZVyxUpN809hZpHAwQAiDZhXqbTUveaFu3DpTyn
vDdM5LZ2oGPjS/3WgoNiFy36R1cnxIh3k/+aM/afU20T//dOn8Cdrh+k868hv9fV
f3YfkyoHzwBCXp8VaOZytkOy7HCLbTEpnnB7MbvrNo1ukOlrFZRVRMSUrco2QD6x
4UYfgBj/zuzxIUZotEnpAmE8ppbMBylqjx+dyIwviDCU0Huw9mEnraBf3Yunuf3k
za92pv/SYJnEFRl2w5ULhtR6GJ3RM8TQJOtWRJjPLkS3L30xvVOQZ1zXoazi/4yX
qp7bKKN/hzC8mPvp8aoCW5c+F652e4pmUplbR4RDaNCD7ipv60XfQBVYOJOGh2YX
+OCYERzFs4th3uPlKNDSfsLHwGY36bPC3mPdiaJW144MX1vHL5YKJiEKcnk5QZNY
BwWidSvdylitAmZeKeCRTOJJh/b+Q7/K72RdWSl6g5qipa/00Gc97Sl/jNOyZ7K6
URPW75jcC/KtA2gIArtL
=fAyc
-----END PGP SIGNATURE-----
