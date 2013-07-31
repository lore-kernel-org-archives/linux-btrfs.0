Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab3GaWux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 18:50:53 -0400
Date: Wed, 31 Jul 2013 15:50:50 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 5/5] Btrfs: online data deduplication
Message-ID: <20130731225050.GN32145@lenny.home.zabbo.net>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-6-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375285066-14173-6-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> +#define BTRFS_DEDUP_HASH_SIZE 32	/* 256bit = 32 * 8bit */
> +#define BTRFS_DEDUP_HASH_LEN 4
> +
> +struct btrfs_dedup_hash_item {
> +	/* FIXME: put a hash type field here */
> +
> +	__le64 hash[BTRFS_DEDUP_HASH_LEN];
> +} __attribute__ ((__packed__));

The handling of hashes in this patch is a mess.

The inconsistent use of _SIZE, _LEN, and literal 4 and the u64 *s being
passed around is asking for mistakes to be made in the future.  And I
don't think it's endian safe.

I think I'd have a struct that represents the native representation of
the tree item.  Something like:

struct btrfs_dedup_hash {
	u64 key_value;
	u8 algo;
	u8 len;
	u8 bytes[0];
}

You can then have helpers that generate that from either the cryptolib
transformation of dedup regions or to and from the tree items.  The
bytes (and the tree item payload) wouldn't need to have the hash bytes
that are stored up in the key. 

- z
