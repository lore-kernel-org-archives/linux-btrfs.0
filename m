Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27188 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3HAKPI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 06:15:08 -0400
Date: Thu, 1 Aug 2013 18:14:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 5/5] Btrfs: online data deduplication
Message-ID: <20130801101457.GB20228@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-6-git-send-email-bo.li.liu@oracle.com>
 <20130731225050.GN32145@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130731225050.GN32145@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 03:50:50PM -0700, Zach Brown wrote:
> 
> > +#define BTRFS_DEDUP_HASH_SIZE 32	/* 256bit = 32 * 8bit */
> > +#define BTRFS_DEDUP_HASH_LEN 4
> > +
> > +struct btrfs_dedup_hash_item {
> > +	/* FIXME: put a hash type field here */
> > +
> > +	__le64 hash[BTRFS_DEDUP_HASH_LEN];
> > +} __attribute__ ((__packed__));
> 
> The handling of hashes in this patch is a mess.
> 
> The inconsistent use of _SIZE, _LEN, and literal 4 and the u64 *s being
> passed around is asking for mistakes to be made in the future.  And I
> don't think it's endian safe.

Yeah, you're right, I missed the endian part for hash.

> 
> I think I'd have a struct that represents the native representation of
> the tree item.  Something like:
> 
> struct btrfs_dedup_hash {
> 	u64 key_value;
> 	u8 algo;
> 	u8 len;
> 	u8 bytes[0];
> }
> 
> You can then have helpers that generate that from either the cryptolib
> transformation of dedup regions or to and from the tree items.  The
> bytes (and the tree item payload) wouldn't need to have the hash bytes
> that are stored up in the key. 

I agree on merging the two structs, btrfs_dedup_item and btrfs_dedup_hash_item,
into one.

So do you mean that our whole hash value will be (key.objectid + bytes)
because key.objectid is a part of hash value?

Thanks for the comments!

-liubo
