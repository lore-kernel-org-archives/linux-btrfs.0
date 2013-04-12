Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:37030 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3DLISn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 04:18:43 -0400
Message-ID: <5167C361.8030508@giantdisaster.de>
Date: Fri, 12 Apr 2013 10:18:41 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] Btrfs-progs: add more subvol fields to btrfs-list
References: <cover.1365696891.git.sbehrens@giantdisaster.de> <97d6694fd9f0b7c14156934fc2215a50bb83a8bc.1365696891.git.sbehrens@giantdisaster.de> <51676693.8080506@cn.fujitsu.com>
In-Reply-To: <51676693.8080506@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Apr 2013 09:42:43 +0800, Wang Shilong wrote:
>> +	if (ritem && !is_v0) {
>> +		rinfo->cgen = btrfs_root_ctransid(ritem);
>> +		rinfo->ogen = btrfs_root_otransid(ritem);
>> +		rinfo->sgen = btrfs_root_stransid(ritem);
>> +		rinfo->rgen = btrfs_root_rtransid(ritem);
>> +		rinfo->ctime = btrfs_stack_timespec_sec(&ritem->ctime);
>> +		rinfo->otime = btrfs_stack_timespec_sec(&ritem->otime);
>> +		rinfo->stime = btrfs_stack_timespec_sec(&ritem->stime);
>> +		rinfo->rtime = btrfs_stack_timespec_sec(&ritem->rtime);
>> +		memcpy(rinfo->uuid, ritem->uuid, BTRFS_UUID_SIZE);
>> +		memcpy(rinfo->puuid, ritem->parent_uuid, BTRFS_UUID_SIZE);
>> +		memcpy(rinfo->ruuid, ritem->received_uuid, BTRFS_UUID_SIZE);
>> +	}
>> +
>> +	/* TODO: this is copied from the old code, what is it good for? */
>> +	if ((!ritem || !btrfs_root_otransid(ritem)) && root_offset)
>> +		rinfo->ogen = root_offset;
> 
> 
> For the older kernel:
> 		subvolume's original generation is always 0, but
> 		for snapshot, root_offset equals to its original generation.
> 		so we set it here.
> 

Thanks for this hint! So it's for old style (v0) root_item entries.
My code above is not correct since it accesses a field that is not available
for v0 root items.

I changed it like this:

@@ -502,11 +502,14 @@ static int set_root_info(struct root_info *rinfo, u64 ref_
                memcpy(rinfo->uuid, ritem->uuid, BTRFS_UUID_SIZE);
                memcpy(rinfo->puuid, ritem->parent_uuid, BTRFS_UUID_SIZE);
                memcpy(rinfo->ruuid, ritem->received_uuid, BTRFS_UUID_SIZE);
-       }
-
-       /* TODO: this is copied from the old code, what is it good for? */
-       if ((!ritem || !btrfs_root_otransid(ritem)) && root_offset)
+       } else if (ritem && is_v0 && root_offset) {
+               /*
+                * old style (v0) root items don't contain an otransid field.
+                * But for snapshots, root_offset equals to its original
+                * generation.
+                */
                rinfo->ogen = root_offset;
+       }

