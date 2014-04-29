Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:40405 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940AbaD2TXI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 15:23:08 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so856182veb.39
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 12:23:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
	<cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
Date: Tue, 29 Apr 2014 20:23:08 +0100
Message-ID: <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 April 2014 17:02, David Sterba <dsterba@suse.cz> wrote:
> The entire device size may not be available to the filesystem, eg. if
> it's modified via resize. Print this information if it can be obtained
> from the DEV_INFO ioctl.
>
> Print the device ID on the same line as the device name and move size to
> the next line.
>
> Sample:
> /dev/sda7, ID: 3
>    Device size:            10.00GiB
>    FS occuppied:            5.00GiB

Spelling mistake.  s/occuppied/occupied/.

>    Data,RAID10:           512.00MiB
>    Metadata,RAID10:       512.00MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             9.00GiB
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  cmds-device.c        |  6 +++---
>  cmds-fi-disk_usage.c | 13 ++++++++++++-
>  cmds-fi-disk_usage.h |  6 +++++-
>  3 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/cmds-device.c b/cmds-device.c
> index 7a9d808b36dd..519725f83e8c 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -447,9 +447,9 @@ static int _cmd_device_usage(int fd, char *path, int mode)
>         }
>
>         for (i = 0; i < device_info_count; i++) {
> -               printf("%s\t%10s\n", device_info_ptr[i].path,
> -                       df_pretty_sizes(device_info_ptr[i].size, mode));
> -
> +               printf("%s, ID: %llu\n", device_info_ptr[i].path,
> +                               device_info_ptr[i].devid);
> +               print_device_sizes(fd, &device_info_ptr[i], mode);
>                 print_device_chunks(fd, device_info_ptr[i].devid,
>                                 device_info_ptr[i].size,
>                                 info_ptr, info_count,
> diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
> index 067c60078710..ddb064cc4c66 100644
> --- a/cmds-fi-disk_usage.c
> +++ b/cmds-fi-disk_usage.c
> @@ -499,7 +499,8 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
>
>                 info[ndevs].devid = dev_info.devid;
>                 strcpy(info[ndevs].path, (char *)dev_info.path);
> -               info[ndevs].size = get_partition_size((char *)dev_info.path);
> +               info[ndevs].device_size = get_partition_size((char *)dev_info.path);
> +               info[ndevs].size = dev_info.total_size;
>                 ++ndevs;
>         }
>
> @@ -879,5 +880,15 @@ void print_device_chunks(int fd, u64 devid, u64 total_size,
>         printf("   Unallocated: %*s%10s\n",
>                 (int)(20 - strlen("Unallocated")), "",
>                 df_pretty_sizes(total_size - allocated, mode));
> +}
>
> +void print_device_sizes(int fd, struct device_info *devinfo, int mode)
> +{
> +       printf("   Device size: %*s%10s\n",
> +               (int)(20 - strlen("Device size")), "",
> +               df_pretty_sizes(devinfo->device_size, mode));
> +       printf("   FS occuppied:%*s%10s\n",

Here too.  s/occuppied/occupied/.

> +               (int)(20 - strlen("FS occupied")), "",
> +               df_pretty_sizes(devinfo->size, mode));
> +       }
>  }
> diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
> index 787b4eb56acf..79cc2a115bc5 100644
> --- a/cmds-fi-disk_usage.h
> +++ b/cmds-fi-disk_usage.h
> @@ -27,7 +27,10 @@ int cmd_filesystem_usage(int argc, char **argv);
>  struct device_info {
>         u64     devid;
>         char    path[BTRFS_DEVICE_PATH_NAME_MAX];
> -       u64     size;
> +       /* Size of the block device */
> +       u64     device_size;
> +       /* Size that's occupied by the filesystem, can be changed via resize */
> +       u64     size;
>  };
>
>  /*
> @@ -50,5 +53,6 @@ char *df_pretty_sizes(u64 size, int mode);
>  void print_device_chunks(int fd, u64 devid, u64 total_size,
>                 struct chunk_info *chunks_info_ptr,
>                 int chunks_info_count, int mode);
> +void print_device_sizes(int fd, struct device_info *devinfo, int mode);
>
>  #endif
> --
> 1.9.0

Same spelling mistake (occuppied) also occurs in the following patches too:
 [PATCH 08/14] btrfs-progs: compare unallocated space against the correct value
 [PATCH 12/14] btrfs-progs: replace df_pretty_sizes with pretty_size_mode

Thanks,
Mike
