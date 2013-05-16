Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9947 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3EPVm4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 17:42:56 -0400
Message-ID: <5195534D.5070505@giantdisaster.de>
Date: Thu, 16 May 2013 23:44:45 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Btrfs-progs: Support UUID tree and UUID items
 in btrfs-debug-tree
References: <cover.1368713962.git.sbehrens@giantdisaster.de> <e1d0089f2ac61b24810ad2f43669059b7343a7bf.1368713962.git.sbehrens@giantdisaster.de> <20130516161942.GA5187@twin.jikos.cz>
In-Reply-To: <20130516161942.GA5187@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/16/2013 18:19, David Sterba wrote:
> On Thu, May 16, 2013 at 04:45:55PM +0200, Stefan Behrens wrote:
>> +struct btrfs_uuid_item {
>> +	__le16 type;	/* refer to BTRFS_UUID_ITEM_TYPE* defines above */
>> +	__le32 len;	/* number of following 64bit values */
>> +	__le64 data[0];	/* data aligned to 64bit */
>> +} __attribute__ ((__packed__));
>
> With __packed__ (which is preferrably written as __packed) the data is
> not aligned to u64 as the comment says. Aligning u64's is a good thing,
> so (for example) pad the space after type (I don't think we need more
> than u16 here).

The on-disk format is in general not aligned (it is "packed") and stored 
on any byte-aligned position on the disk.

In the source code, you can use it for sizeof(), otherwise you use the 
access functions from ctree.h and struct-funcs.c.

I know that you know this already :) Maybe I am not understanding your 
review comment?

The "data" part in the btrfs_uuid_item (which represents the "value" of 
the (type, length, value) tripple) is a multiple of 64 bits, that's what 
I mean with the "data aligned to 64bit" comment.

