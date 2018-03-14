Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:33163 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbeCNIyC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:54:02 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: FS unmountable after RAID/LVM problems
In-Reply-To: <e134bae6-d316-fcda-d0c5-0b0ae7d56edb@gmx.com> (Qu Wenruo's
        message of "Wed, 14 Mar 2018 08:40:11 +0800")
References: <ghlgew5pbq.fsf@lena.gouders.net>
        <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
        <ghwoygxh77.fsf@lena.gouders.net>
        <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
        <ghsh94xfx9.fsf@lena.gouders.net>
        <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
        <gho9jsxdii.fsf@lena.gouders.net>
        <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
        <ghk1ugxc6m.fsf@lena.gouders.net>
        <e134bae6-d316-fcda-d0c5-0b0ae7d56edb@gmx.com>
Date: Wed, 14 Mar 2018 09:53:54 +0100
Message-ID: <ghlgevjavx.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年03月13日 22:49, Dirk Gouders wrote:
> [snip]
>>>
>>> # btrfs inspect dump-tree -b 848986112 /dev/loop0p1
>>> # btrfs inspect dump-tree -b 72089600 /dev/loop0p1
>> 
>> OK.
>> 
>> (This mail gets a bit long but I don't want to snip probably important
>>  information above.)
>> 
>
> Feel free to snip.
> As the involved tree block is not shown anywhere.
>
> So it's not any root node corrupted.
> It may be some extent tree node corrupted in this case.
>
> While to inspect it, we need some new functionality in btrfs inspect tree.
>
> Before that, would you please try the following patch and to see if it
> helps btrfs-restore to salvage any data?

I tried it and got the following output:

# btrfs restore /dev/loop0p1 /mnt/
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
Could not open root, trying backup super
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 10741612544
Could not open root, trying backup super


Because the patch did not apply, I did the modification manually as
follows:

# git diff
diff --git a/cmds-restore.c b/cmds-restore.c
index ade35f0f..e7b96a67 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1282,7 +1282,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
        for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
                bytenr = btrfs_sb_offset(i);
                fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0,
-                                            OPEN_CTREE_PARTIAL);
+                                            OPEN_CTREE_PARTIAL | __OPEN_CTREE_RETURN_CHUNK_ROOT);
                if (fs_info)
                        break;
                fprintf(stderr, "Could not open root, trying backup super\n");

Thanks,

Dirk
