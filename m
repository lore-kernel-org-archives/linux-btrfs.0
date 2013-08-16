Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48293 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3HPCZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 22:25:18 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so1596212pdj.29
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Aug 2013 19:25:18 -0700 (PDT)
Received: from [192.168.1.100] ([223.65.188.145])
        by mx.google.com with ESMTPSA id in2sm2684902pbc.37.2013.08.15.19.25.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 15 Aug 2013 19:25:17 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] btrfs-progs: restore passing of super_bytenr to device scan
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <67B4D19F-4777-4294-9358-F13366D1D0FF@gmail.com>
Date: Fri, 16 Aug 2013 10:25:12 +0800
Message-Id: <AFCFCA62-F037-46F7-87EE-6410BD193613@gmail.com>
References: <520D7582.3050804@suse.com> <67B4D19F-4777-4294-9358-F13366D1D0FF@gmail.com>
To: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add to the  list
> Helo,
> 
> I have sent a patch for this before:
> 
> https://patchwork.kernel.org/patch/2828820/
> 
> Thanks,
> Wang
> 
>> Commit 615f2867 (Btrfs-progs: cleanup similar code in open_ctree_*
>> and close_ctree) introduced a regression in btrfs-convert.
>> 
>> open_ctree takes a sb_bytenr argument to specify where to find the
>> superblock. Under normal conditions, this will be at BTRFS_SUPER_INFO_OFFSET,
>> and that commit assumed as much under all conditions.
>> 
>> make_btrfs allows the caller to specify which blocks to use for
>> certain blocks (including the superblock) and this is used by btrfs-convert
>> to avoid overwriting the source file system's superblock until the
>> conversion is complete.
>> 
>> When btrfs-convert goes to open the newly initialized file system, it
>> fails with: "No valid btrfs found" since its superblock wasn't written
>> to the normal location.
>> 
>> This patch restores the passing down of super_bytesnr to
>> btrfs_scan_one_device.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>> btrfs-find-root.c |  2 +-
>> cmds-chunk.c      |  2 +-
>> disk-io.c         | 10 +++++++---
>> disk-io.h         |  3 ++-
>> 4 files changed, 11 insertions(+), 6 deletions(-)
>> 
>> diff --git a/btrfs-find-root.c b/btrfs-find-root.c
>> index 9b3d7df..374cf81 100644
>> --- a/btrfs-find-root.c
>> +++ b/btrfs-find-root.c
>> @@ -82,7 +82,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>> 		return NULL;
>> 	}
>> 
>> -	ret = btrfs_scan_fs_devices(fd, device, &fs_devices);
>> +	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0);
>> 	if (ret)
>> 		goto out;
>> 
>> diff --git a/cmds-chunk.c b/cmds-chunk.c
>> index 03314de..6ada328 100644
>> --- a/cmds-chunk.c
>> +++ b/cmds-chunk.c
>> @@ -1291,7 +1291,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
>> 		goto fail_free_sb;
>> 	}
>> 
>> -	ret = btrfs_scan_fs_devices(fd, path, &fs_devices);
>> +	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0);
>> 	if (ret)
>> 		goto fail_free_sb;
>> 
>> diff --git a/disk-io.c b/disk-io.c
>> index 13dbe27..1b91de6 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -909,13 +909,17 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
>> }
>> 
>> int btrfs_scan_fs_devices(int fd, const char *path,
>> -			  struct btrfs_fs_devices **fs_devices)
>> +			  struct btrfs_fs_devices **fs_devices,
>> +			  u64 super_bytenr)
>> {
>> 	u64 total_devs;
>> 	int ret;
>> 
>> +	if (super_bytenr == 0)
>> +		super_bytenr = BTRFS_SUPER_INFO_OFFSET;
>> +
>> 	ret = btrfs_scan_one_device(fd, path, fs_devices,
>> -				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
>> +				    &total_devs, super_bytenr);
>> 	if (ret) {
>> 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
>> 		return ret;
>> @@ -1001,7 +1005,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>> 	if (restore)
>> 		fs_info->on_restoring = 1;
>> 
>> -	ret = btrfs_scan_fs_devices(fp, path, &fs_devices);
>> +	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr);
>> 	if (ret)
>> 		goto out;
>> 
>> diff --git a/disk-io.h b/disk-io.h
>> index effaa9f..d7792e0 100644
>> --- a/disk-io.h
>> +++ b/disk-io.h
>> @@ -59,7 +59,8 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
>> void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
>> void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
>> int btrfs_scan_fs_devices(int fd, const char *path,
>> -			  struct btrfs_fs_devices **fs_devices);
>> +			  struct btrfs_fs_devices **fs_devices,
>> +			  u64 super_bytenr);
>> int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
>> 
>> struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
>> -- 
>> 1.8.1.4
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

