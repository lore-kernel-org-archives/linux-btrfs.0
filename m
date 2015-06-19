Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15921 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266AbbFSBko (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 21:40:44 -0400
Subject: Re: btrfs-progs 4.1-rc1: btrfstune -u reporting incorrect current
 fsid?
To: <dsterba@suse.cz>, Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAMU1PDjKbbXPrr5uPgPUEzfN+RWxi9McvRLS02N7N9JJ39q2ug@mail.gmail.com>
 <20150618173332.GJ6761@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55837315.90109@cn.fujitsu.com>
Date: Fri, 19 Jun 2015 09:40:37 +0800
MIME-Version: 1.0
In-Reply-To: <20150618173332.GJ6761@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/06/18 19:33 +0200:
> On Wed, Jun 17, 2015 at 10:21:45PM +0100, Mike Fleetwood wrote:
>> It also upper cases the UUID where as btrfs fi sh and blkid don't.
>
> Ok, I'll switch that to lowercase so it's consistent with the rest.
>
>> I've done a quick test on changing the UUID of a btrfs.  It worked, but
>> btrfstune -u didn't print the same current uuid that btrfs fi sh does.
>
> Seems that the reporting is broken in the btrfstune side. I've
> reproduced it here. I've used btrfs-show-super in the tests and did not
> notice that the 'current fsid' is wrong. Thanks.

Just a little tip to take less time on the bug:
---
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -349,7 +349,7 @@ static int change_uuid(struct btrfs_fs_info 
*fs_info, const char *new_fsid_str)
         fs_info->new_fsid = new_fsid;
         fs_info->new_chunk_tree_uuid = new_chunk_id;

-       uuid_parse((const char*)fs_info->fsid, old_fsid);
+       memcpy(old_fsid, fs_info->fsid, BTRFS_UUID_SIZE);
         uuid_unparse_upper(old_fsid, uuid_buf);
         printf("Current fsid: %s\n", uuid_buf);

---

Also, you can remove the old_fsid variant if you want and just use 
fs_info->fsid.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
