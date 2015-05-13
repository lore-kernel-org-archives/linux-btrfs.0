Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623AbbEMN5k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 09:57:40 -0400
Date: Wed, 13 May 2015 15:57:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 01/13] btrfs-progs: Add CHANGIND_FSID and
 CHANGING_CHUNK_TREE_ID super flags.
Message-ID: <20150513135738.GL23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431331734-11714-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431331734-11714-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 04:08:42PM +0800, Qu Wenruo wrote:
> @@ -307,6 +307,8 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>  
>  #define BTRFS_HEADER_FLAG_WRITTEN		(1ULL << 0)
>  #define BTRFS_HEADER_FLAG_RELOC			(1ULL << 1)
> +#define BTRFS_SUPER_FLAG_CHANGING_FSID		(1ULL << 30)
> +#define BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID	(1ULL << 31)

Seems that the values should continue from the end of the sequence, ie.
1 << 35, I'll change that.

>  #define BTRFS_SUPER_FLAG_SEEDING		(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP		(1ULL << 33)
>  #define BTRFS_SUPER_FLAG_METADUMP_V2		(1ULL << 34)
