Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:55272 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3DLJF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 05:05:27 -0400
Message-ID: <5167CE55.6040309@giantdisaster.de>
Date: Fri, 12 Apr 2013 11:05:25 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] Btrfs-progs: add more subvol fields to btrfs-list
In-Reply-To: <5167C85B.50106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <140ca9fdec9d22e8841bc0309ba2e70fff7539bd.1365754038.git.sbehrens@giantdisaster.de>
 <5167C85B.50106@cn.fujitsu.com>

On Fri, 12 Apr 2013 16:39:55 +0800, Wang Shilong wrote:
[...]
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
> 
>> +	} else if (ritem && is_v0 && root_offset) {
>> +		/*
>> +		 * old style (v0) root items don't contain an otransid field.
>> +		 * But for snapshots, root_offset equals to its original
>> +		 * generation.
>> +		 */
>> +		rinfo->ogen = root_offset;
>> +	}
> 
> 
> 	We set it rinfo->ogen = root_offset only if:
> 	1> for root_item_v0
> 	2> it is a snapshot.
> 
> 	Besides for a snapshot it's root_offset is always none zero.
> 	so we do not need (is_v0 && root_offset) both.
> 	Actually, Patch V2 doses the correct thing.
> 

Patch V2 was accessing the otransid field also for root_item_v0 which
does not have this field. This was not correct.

That root_offset != 0 thing is because add_root() and therefore
set_root_info() is called twice, once for BTRFS_ROOT_BACKREF_KEY and
once for BTRFS_ROOT_ITEM_KEY. In both cases, the arguments to add_root()
are only partially supplied and those values that are not available are
set to zero. The old code everywhere had this ... != 0 else don't set
the value, to handle this double call to add_root(), and I replaced most
of it by passing a root_item pointer of NULL in the BACKREF case (where
the old code just set gen=0, time=0, uuid=0 ...), and reading the values
of the root_item down in set_root_info() in the ROOT_ITEM case. Only
root_offset remains which is set to 0 in the BACKREF case and to the
key's offset value in the ROOT_ITEM case. One could now argue that in
the first case where root_offset is not valid, ritem is set to NULL and
therefore the equation (ritem && is_v0 && root_offset) is equal to
(ritem && is_v0), but IMHO a deep subfunction should not make use of too
much information that is part of the functions that call the subfunction.

Summary: Patch V3 does the correct thing.

