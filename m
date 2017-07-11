Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53647 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932475AbdGKRam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 13:30:42 -0400
Date: Tue, 11 Jul 2017 19:29:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 10/13] btrfs: backref, add tracepoints for prelim_ref
 insertion and merging
Message-ID: <20170711172928.GZ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
 <20170629035705.1589-11-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629035705.1589-11-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:57:02PM -0600, Edmund Nadolski wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> +DECLARE_EVENT_CLASS(btrfs__prelim_ref,
> +	TP_PROTO(const struct btrfs_fs_info *fs_info,
> +		 const struct prelim_ref *oldref,
> +		 const struct prelim_ref *newref, u64 tree_size),
> +	TP_ARGS(fs_info, newref, oldref, tree_size),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,  root_id		)
> +		__field(	u64,  objectid		)
> +		__field(	 u8,  type		)
> +		__field(	u64,  offset		)
> +		__field(	int,  level		)
> +		__field(	int,  old_count		)
> +		__field(	u64,  parent		)
> +		__field(	u64,  bytenr		)
> +		__field(	int,  mod_count		)
> +		__field(	u64, tree_size		)
> +	),
> +
> +	TP_fast_assign_btrfs(fs_info,
> +		__entry->root_id	= oldref->root_id;
> +		__entry->objectid	= oldref->key_for_search.objectid;
> +		__entry->type		= oldref->key_for_search.type;
> +		__entry->offset		= oldref->key_for_search.offset;
> +		__entry->level		= oldref->level;
> +		__entry->old_count	= oldref->count;
> +		__entry->parent		= oldref->parent;
> +		__entry->bytenr		= oldref->wanted_disk_byte;
> +		__entry->mod_count	= newref ? newref->count : 0;
> +		__entry->tree_size	= tree_size;
> +	),
> +
> +	TP_printk_btrfs("root=%llu, key=[%llu, %u, %llu], level=%d, count=[%d+%d=%d], parent=%llu, wanted_disk_byte=%llu, nodes=%llu",

Please update the format according to the recommendations

https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints
