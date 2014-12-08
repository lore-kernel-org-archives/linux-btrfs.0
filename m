Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41269 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaLHO46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:56:58 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so3844619wgg.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 06:56:57 -0800 (PST)
Message-ID: <5485BC81.5000906@gmail.com>
Date: Mon, 08 Dec 2014 15:58:09 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/5] Avoid to consider lvm snapshots when scanning devices.
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <1417718382-6753-2-git-send-email-kreijack@inwind.it> <548506A3.3010409@cn.fujitsu.com>
In-Reply-To: <548506A3.3010409@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2014 03:02 AM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: [PATCH 1/5] Avoid to consider lvm snapshots when scanning devices.
> From: Goffredo Baroncelli <kreijack@gmail.com>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2014年12月05日 02:39
>> LVM snapshots create a problem to the btrfs devices management.
>> BTRFS assumes that each device haw an unique 'device UUID'.
>> A LVM snapshot breaks this assumption.
>>
>> This patch skips LVM snapshots during the device scan phase.
>> If you need to consider a LVM snapshot you have to set the
>> environmental variable BTRFS_SKIP_LVM_SNAPSHOT to "no".
> IMHO, it is better only to skip LVM snapshot if and only if the snapshot contains a btrfs with
> conflicting UUID.

Hi Qu,

Currently the "scan phase" in btrfs is done 1 device at time.
(udev finds a new device and starts "btrfs dev scan <device>"),
and I haven't changed that. This means that btrfs[-prog] doesn't 
know which devices are already registered, or not. And if even 
it would know this information, you have to consider the case
where the snapshot appears before the real target. So 
btrfs[-prog] is not in position to perform this analysis [see
below my other comment]

> Since LVM is such a flexible block level volume management, it is possible that some one
> did a snapshot of a btrfs fs, and then reformat the original one to other fs.
> In that case, the LVM snapshot skip seems overkilled.
> 
> Also, personally, I prefer there will be some option like -i to allow user to choose which device is
> used when conflicting uuid is detected. This seems to be the best case and user can have the full control
> on device scan. This also makes the environment variant not needed.
> 
> LVM snapshot skip (only when conflicting) is better to be the fallback behavior if -i is not given.

I understood your reasons, but I don't find any solution 
compatible with the current btrfs device registration model
(asynchronously when the device appears).

In another patch set, I proposed a mount.btrfs helper which is
in position to perform these analysis and to pick the "right"
device (even with the user suggestion).

Today the lvm-snapshot and btrfs behave very poor: it is not
predictable which device is pick (the original or the snapshot). 
These patch *avoid* most problems skipping the snapshots, which
to me seems a reasonable default.
For the other case the user is still able to mount any disks
[combination] passing them directly via command line (
mount /dev/sdX -o device=/dev/sdY,device=/dev/sdz...  );

Anyway I think for these kind of setup (btrfs on lvm-snapshot), 
passing the disks explicitly is the only solution; in fact your 
suggestion about the '-i' switch is not very different.

> Thanks,
> Qu

BR
G.Baroncelli
>>
>> To check if a device is a LVM snapshot, it is checked the
>> 'udev' device property 'DM_UDEV_LOW_PRIORITY_FLAG' .
>> If it is set to 1, the device has to be skipped.
>>
>> As conseguence, btrfs now depends by libudev.
>>
>> Programmatically you can control this behavior with the functions:
>> - btrfs_scan_set_skip_lvm_snapshot(int new_value)
>> - int btrfs_scan_get_skip_lvm_snapshot( )
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>   Makefile |   4 +--
>>   utils.c  | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   utils.h  |   9 +++++-
>>   3 files changed, 117 insertions(+), 3 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 4cae30c..9464361 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -26,7 +26,7 @@ TESTS = fsck-tests.sh convert-tests.sh
>>   INSTALL = install
>>   prefix ?= /usr/local
>>   bindir = $(prefix)/bin
>> -lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
>> +lib_LIBS = -luuid -lblkid -lm -lz -ludev -llzo2 -L.
>>   libdir ?= $(prefix)/lib
>>   incdir = $(prefix)/include/btrfs
>>   LIBS = $(lib_LIBS) $(libs_static)
>> @@ -99,7 +99,7 @@ lib_links = libbtrfs.so.0 libbtrfs.so
>>   headers = $(libbtrfs_headers)
>>     # make C=1 to enable sparse
>> -check_defs := .cc-defines.h
>> +check_defs := .cc-defines.h
>>   ifdef C
>>       #
>>       # We're trying to use sparse against glibc headers which go wild
>> diff --git a/utils.c b/utils.c
>> index 2a92416..9887f8b 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -29,6 +29,7 @@
>>   #include <sys/types.h>
>>   #include <sys/stat.h>
>>   #include <uuid/uuid.h>
>> +#include <libudev.h>
>>   #include <fcntl.h>
>>   #include <unistd.h>
>>   #include <mntent.h>
>> @@ -52,6 +53,13 @@
>>   #define BLKDISCARD    _IO(0x12,119)
>>   #endif
>>   +/*
>> + * This variable controls if the lvm snapshot have to be skipped or not.
>> + * Access this variable only via the btrfs_scan_[sg]et_skip_lvm_snapshot()
>> + * functions
>> + */
>> +static int __scan_device_skip_lvm_snapshot = -1;
>> +
>>   static int btrfs_scan_done = 0;
>>     static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
>> @@ -1593,6 +1601,9 @@ int btrfs_scan_block_devices(int run_ioctl)
>>       char fullpath[110];
>>       int scans = 0;
>>       int special;
>> +    int skip_snapshot;
>> +
>> +    skip_snapshot = btrfs_scan_get_skip_lvm_snapshot();
>>     scan_again:
>>       proc_partitions = fopen("/proc/partitions","r");
>> @@ -1642,6 +1653,9 @@ scan_again:
>>               continue;
>>           }
>>   +        if (skip_snapshot && is_low_priority_device(fullpath))
>> +            continue;
>> +
>>           fd = open(fullpath, O_RDONLY);
>>           if (fd < 0) {
>>               if (errno != ENOMEDIUM)
>> @@ -2182,6 +2196,30 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
>>       return 0;
>>   }
>>   +int btrfs_scan_get_skip_lvm_snapshot( )
>> +{
>> +    const char *value;
>> +
>> +    if (__scan_device_skip_lvm_snapshot != -1 )
>> +        return __scan_device_skip_lvm_snapshot;
>> +
>> +    value = getenv(BTRFS_SKIP_LVM_SNAPSHOT_ENV_NAME);
>> +    if (value && !strcasecmp(value, "NO"))
>> +        __scan_device_skip_lvm_snapshot = 0;
>> +    else  if (value && !strcasecmp(value, "YES"))
>> +        __scan_device_skip_lvm_snapshot = 1;
>> +    else
>> +        __scan_device_skip_lvm_snapshot =
>> +            BTRFS_SKIP_LVM_SNAPSHOT_DEFAULT;
>> +
>> +    return __scan_device_skip_lvm_snapshot;
>> +}
>> +
>> +void btrfs_scan_set_skip_lvm_snapshot(int new_value)
>> +{
>> +    __scan_device_skip_lvm_snapshot = !!new_value;
>> +}
>> +
>>   int btrfs_scan_lblkid()
>>   {
>>       int fd = -1;
>> @@ -2192,6 +2230,9 @@ int btrfs_scan_lblkid()
>>       blkid_dev dev = NULL;
>>       blkid_cache cache = NULL;
>>       char path[PATH_MAX];
>> +    int skip_snapshot;
>> +
>> +    skip_snapshot = btrfs_scan_get_skip_lvm_snapshot();
>>         if (btrfs_scan_done)
>>           return 0;
>> @@ -2210,6 +2251,9 @@ int btrfs_scan_lblkid()
>>           /* if we are here its definitely a btrfs disk*/
>>           strncpy(path, blkid_dev_devname(dev), PATH_MAX);
>>   +        if (skip_snapshot && is_low_priority_device(path))
>> +            continue;
>> +
>>           fd = open(path, O_RDONLY);
>>           if (fd < 0) {
>>               printf("ERROR: could not open %s\n", path);
>> @@ -2450,3 +2494,66 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
>>       }
>>       return 1;
>>   }
>> +
>> +/*
>> + * This function return 1 if the device (path) is consdered "LOW_PRIORITY" by
>> + * LVM2 library. These device are typically the nsapshot.
>> + * This function return < 0 in case of error; 0 otherwise.
>> + */
>> +int is_low_priority_device(const char *path)
>> +{
>> +
>> +    struct udev *udev=NULL;
>> +    struct udev_device *dev;
>> +    struct udev_enumerate *enumerate=NULL;
>> +    struct udev_list_entry *devices;
>> +    struct udev_list_entry *node, *list;
>> +    int ret=-1;
>> +    const char *value, *syspath;
>> +    char *rpath=NULL;
>> +
>> +    rpath = realpath(path, NULL);
>> +    if (!rpath) {
>> +        fprintf(stderr, "ERROR: not enough memory\n");
>> +        ret=-2;
>> +        goto exit;
>> +    }
>> +
>> +    /* Create the udev object */
>> +    udev = udev_new();
>> +    if (!udev) {
>> +        fprintf(stderr, "ERROR: Can't create udev\n");
>> +        ret=-1;
>> +        goto exit;
>> +    }
>> +
>> +    enumerate = udev_enumerate_new(udev);
>> +    udev_enumerate_add_match_subsystem(enumerate, "block");
>> +    udev_enumerate_add_match_property(enumerate, "DEVNAME", rpath);
>> +    udev_enumerate_scan_devices(enumerate);
>> +
>> +    devices = udev_enumerate_get_list_entry(enumerate);
>> +    syspath = udev_list_entry_get_name(devices);
>> +
>> +    dev = udev_device_new_from_syspath(udev, syspath);
>> +
>> +    list = udev_device_get_properties_list_entry (dev);
>> +
>> +    ret = 0;
>> +    node = udev_list_entry_get_by_name(list, "DM_UDEV_LOW_PRIORITY_FLAG");
>> +    if (node) {
>> +        value = udev_list_entry_get_value(node);
>> +        if (value && !strcmp(value, "1"))
>> +            ret = 1;
>> +    }
>> +
>> +exit:
>> +    free(rpath);
>> +
>> +    /* Free the enumerator object */
>> +    udev_enumerate_unref(enumerate);
>> +
>> +    udev_unref(udev);
>> +
>> +    return ret;
>> +}
>> diff --git a/utils.h b/utils.h
>> index 289e86b..9855f09 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -128,7 +128,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
>>                  int verify);
>>   int ask_user(char *question);
>>   int lookup_ino_rootid(int fd, u64 *rootid);
>> -int btrfs_scan_lblkid(void);
>> +int btrfs_scan_lblkid();
>>   int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
>>   int find_mount_root(const char *path, char **mount_root);
>>   int get_device_info(int fd, u64 devid,
>> @@ -161,4 +161,11 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
>>     int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
>>   +#define BTRFS_SKIP_LVM_SNAPSHOT_DEFAULT 1
>> +#define BTRFS_SKIP_LVM_SNAPSHOT_ENV_NAME "BTRFS_SKIP_LVM_SNAPSHOT"
>> +
>> +int is_low_priority_device(const char *path);
>> +void btrfs_scan_set_skip_lvm_snapshot(int new_value);
>> +int btrfs_scan_get_skip_lvm_snapshot( );
>> +
>>   #endif
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
