Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3EPQTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 12:19:45 -0400
Date: Thu, 16 May 2013 18:19:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Btrfs-progs: Support UUID tree and UUID items in
 btrfs-debug-tree
Message-ID: <20130516161942.GA5187@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1368713962.git.sbehrens@giantdisaster.de>
 <e1d0089f2ac61b24810ad2f43669059b7343a7bf.1368713962.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e1d0089f2ac61b24810ad2f43669059b7343a7bf.1368713962.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 04:45:55PM +0200, Stefan Behrens wrote:
> +struct btrfs_uuid_item {
> +	__le16 type;	/* refer to BTRFS_UUID_ITEM_TYPE* defines above */
> +	__le32 len;	/* number of following 64bit values */
> +	__le64 data[0];	/* data aligned to 64bit */
> +} __attribute__ ((__packed__));

With __packed__ (which is preferrably written as __packed) the data is
not aligned to u64 as the comment says. Aligning u64's is a good thing,
so (for example) pad the space after type (I don't think we need more
than u16 here).

david
