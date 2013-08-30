Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3H3QQy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 12:16:54 -0400
Date: Fri, 30 Aug 2013 18:16:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/15] btrfs-progs: fix endian bugs in chunk rebuilding
Message-ID: <20130830161652.GO23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-8-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376522205-16992-8-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 04:16:37PM -0700, Zach Brown wrote:
> I *think* the second one is just a typo.  The chunk's num_stripes was
> already initialized from the record, but it's le16.  So we'll set the
> item's size based on the record's native num_stripes.

> @@ -1117,7 +1117,7 @@ static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
>  		key.offset = chunk_rec->offset;
>  
>  		ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
> -				btrfs_chunk_item_size(chunk->num_stripes));
> +				btrfs_chunk_item_size(chunk_rec->num_stripes));

AFAICS, this is an equivalent change, chunk gets copied from chunk_rec
via create_chunk_item a few lines above. It looks more consistent with
chunk_rec, though.

>  		free(chunk);
>  		if (ret)
>  			return ret;
