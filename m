Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaBJAiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 19:38:23 -0500
Message-ID: <52F81FA6.1050704@cn.fujitsu.com>
Date: Mon, 10 Feb 2014 08:39:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add -p/--print-missing options for btrfs
 fi show
References: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com> <1391755560-4721-2-git-send-email-quwenruo@cn.fujitsu.com> <52F4A6B3.4000007@oracle.com>
In-Reply-To: <52F4A6B3.4000007@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 07 Feb 2014 17:26:11 +0800, Anand Jain wrote:
>
>  Whats needed is more comprehensive btrfs fi show
>  which shows the flags (including missing) per disk.
Yes indeed.
>  And also show the FS/Raid status. Which I am working on.
>
>  sorry -p feature would be covered by default in the
>  coming revamp of btrfs fi show.
That's all right.
Just a kind remind, if the output format changes, don't forget to modify 
the related xfstests testcase.

Thanks,
Qu
>
> Thanks, Anand
>
>
> On 02/07/2014 02:46 PM, Qu Wenruo wrote:
>> Since a mounted btrfs filesystem contains all the devices info even a
>> device is removed after mount(like btrfs/003 in xfstests),
>> we can use the info to print the known missing device if possible.
>>
>> So -p/--print-missing options are added to print possible missing
>> devices.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   cmds-filesystem.c | 26 ++++++++++++++++++++------
>>   man/btrfs.8.in    |  4 +++-
>>   2 files changed, 23 insertions(+), 7 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index 4c9933d..77b142c 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -360,7 +360,7 @@ static u64 calc_used_bytes(struct 
>> btrfs_ioctl_space_args *si)
>>   static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>>           struct btrfs_ioctl_dev_info_args *dev_info,
>>           struct btrfs_ioctl_space_args *space_info,
>> -        char *label, char *path)
>> +        char *label, char *path, int print_missing)
>>   {
>>       int i;
>>       int fd;
>> @@ -392,7 +392,14 @@ static int print_one_fs(struct 
>> btrfs_ioctl_fs_info_args *fs_info,
>>           fd = open((char *)tmp_dev_info->path, O_RDONLY);
>>           if (fd < 0) {
>>               missing = 1;
>> -            continue;
>> +            if (print_missing)
>> +                printf("\tdevid %4llu size %s used %s path %s 
>> (missing)\n",
>> +                       tmp_dev_info->devid,
>> + pretty_size(tmp_dev_info->total_bytes),
>> + pretty_size(tmp_dev_info->bytes_used),
>> +                       tmp_dev_info->path);
>> +            else
>> +                continue;
>>           }
>>           close(fd);
>>           printf("\tdevid %4llu size %s used %s path %s\n",
>> @@ -440,7 +447,7 @@ static int check_arg_type(char *input)
>>       return BTRFS_ARG_UNKNOWN;
>>   }
>>
>> -static int btrfs_scan_kernel(void *search)
>> +static int btrfs_scan_kernel(void *search, int print_missing)
>>   {
>>       int ret = 0, fd;
>>       FILE *f;
>> @@ -477,7 +484,8 @@ static int btrfs_scan_kernel(void *search)
>>           fd = open(mnt->mnt_dir, O_RDONLY);
>>           if ((fd != -1) && !get_df(fd, &space_info_arg)) {
>>               print_one_fs(&fs_info_arg, dev_info_arg,
>> -                    space_info_arg, label, mnt->mnt_dir);
>> +                     space_info_arg, label, mnt->mnt_dir,
>> +                     print_missing);
>>               kfree(space_info_arg);
>>               memset(label, 0, sizeof(label));
>>           }
>> @@ -500,6 +508,7 @@ static const char * const cmd_show_usage[] = {
>>       "Show the structure of a filesystem",
>>       "-d|--all-devices   show only disks under /dev containing btrfs 
>> filesystem",
>>       "-m|--mounted       show only mounted btrfs",
>> +    "-p|--print-missing show known missing device if possible",
>>       "If no argument is given, structure of all present filesystems 
>> is shown.",
>>       NULL
>>   };
>> @@ -513,6 +522,7 @@ static int cmd_show(int argc, char **argv)
>>       int ret;
>>       int where = BTRFS_SCAN_LBLKID;
>>       int type = 0;
>> +    int print_missing = 0;
>>       char mp[BTRFS_PATH_NAME_MAX + 1];
>>       char path[PATH_MAX];
>>
>> @@ -521,9 +531,10 @@ static int cmd_show(int argc, char **argv)
>>           static struct option long_options[] = {
>>               { "all-devices", no_argument, NULL, 'd'},
>>               { "mounted", no_argument, NULL, 'm'},
>> +            { "print-missing", no_argument, NULL, 'p'},
>>               { NULL, no_argument, NULL, 0 },
>>           };
>> -        int c = getopt_long(argc, argv, "dm", long_options,
>> +        int c = getopt_long(argc, argv, "dmp", long_options,
>>                       &long_index);
>>           if (c < 0)
>>               break;
>> @@ -534,6 +545,9 @@ static int cmd_show(int argc, char **argv)
>>           case 'm':
>>               where = BTRFS_SCAN_MOUNTED;
>>               break;
>> +        case 'p':
>> +            print_missing = 1;
>> +            break;
>>           default:
>>               usage(cmd_show_usage);
>>           }
>> @@ -571,7 +585,7 @@ static int cmd_show(int argc, char **argv)
>>           goto devs_only;
>>
>>       /* show mounted btrfs */
>> -    ret = btrfs_scan_kernel(search);
>> +    ret = btrfs_scan_kernel(search, print_missing);
>>       if (search && !ret)
>>           return 0;
>>
>> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
>> index 8fea115..db2e355 100644
>> --- a/man/btrfs.8.in
>> +++ b/man/btrfs.8.in
>> @@ -25,7 +25,7 @@ btrfs \- control a btrfs filesystem
>>   .PP
>>   \fBbtrfs\fP \fBfilesystem df\fP\fI <path>\fP
>>   .PP
>> -\fBbtrfs\fP \fBfilesystem show\fP 
>> [\fI--mounted\fP|\fI--all-devices\fP|\fI<uuid>\fP]\fP
>> +\fBbtrfs\fP \fBfilesystem show\fP 
>> [\fI--mounted\fP|\fI--all-devices\fP|\fI--print-missing\fP|\fI<uuid>\fP]\fP
>>   .PP
>>   \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
>>   .PP
>> @@ -280,6 +280,8 @@ and unmounted.
>>   If \fB--mounted\fP is passed, it would probe btrfs kernel to list 
>> mounted btrfs filesystem(s);
>>   If \fB--all-devices\fP is passed, all the devices under /dev are 
>> scanned;
>>   otherwise the devices list is extracted from the /proc/partitions 
>> file.
>> +If \fB--print-missing\fP is passed, btrfs will try its best to print 
>> the missing device.
>> +This option is only useful if the filesystem is already mounted 
>> since mounted filesystem may contain the device list.
>>   .TP
>>
>>   \fBfilesystem sync\fR\fI <path> \fR
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

