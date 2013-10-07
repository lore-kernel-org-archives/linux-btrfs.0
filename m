Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39264 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3JGKOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 06:14:06 -0400
Message-ID: <52528B1A.5030402@oracle.com>
Date: Mon, 07 Oct 2013 18:21:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: create helper function to use lblkid to
 scan for btrfs disks
References: <1380296700-7232-1-git-send-email-anand.jain@oracle.com> <5245ADFC.2090706@oracle.com> <3CB50CC0-506D-4B7B-B66B-D01FC021BF63@gmail.com> <20131001120352.GB18291@twin.jikos.cz>
In-Reply-To: <20131001120352.GB18291@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>> Following this patch the idea is to use lblkid to scan
>>> for the btrfs disks by default which means we don't
>>> use BTRFS_SCAN_PROC any more.
>>
>> Firstly, i would like to know if we will get any different results between scanning
>> /proc/partions and using lbkid.
>
> I take blkid as a more authoritative source, /proc/partitions was a
> workaround to avoid scanning the whole /dev directory.
>
>> If not, why we can use liblkid totally,since this is more simple.
>
> Agreed, blkid by default and --all-devices as a last resort fallback.


compiled using BTRFS_SCAN_LBLKID as default.
---
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -402,7 +402,8 @@ static int cmd_show(int argc, char **argv)
         struct list_head *cur_uuid;
         char *search = NULL;
         int ret;
-       int where = BTRFS_SCAN_PROC;
+       int where = BTRFS_SCAN_LBLKID;
         int type = 0;

         while (1) {
------

# btrfs fi show
Label: none  uuid: c114c6ce-58a1-4e2c-839e-b53c5ba5ba75
	Total devices 1 FS bytes used 756.00KiB
	devid    1 size 1.10GiB used 324.00MiB path /dev/mapper/mpathg
---

recompiled to use BTRFS_SCAN_PROC as in original.
---
# btrfs fi show
Label: none  uuid: c114c6ce-58a1-4e2c-839e-b53c5ba5ba75
	Total devices 1 FS bytes used 36.00KiB
	devid    1 size 1.10GiB used 148.62MiB path /dev/dm-2
---


 > The proc workaround can go away.

  The other choice is to use both, 'BTRFS_SCAN_PROC | BTRFS_SCAN_DEV'
  for --all-devices option. in that way proc-way will still be in there.

Thanks, Anand

