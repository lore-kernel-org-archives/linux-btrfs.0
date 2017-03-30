Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933160AbdC3NJm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 09:09:42 -0400
Date: Thu, 30 Mar 2017 15:08:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 6/9] btrfs: qgroup: Return actually freed bytes for
 qgroup release or free data
Message-ID: <20170330130857.GI4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-7-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-7-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:13PM +0800, Qu Wenruo wrote:
> btrfs_qgroup_release/free_data() only returns 0 or minus error
> number(ENOMEM is the only possible error).

btrfs_qgroup_release_data -> __btrfs_qgroup_release_data
will not allocate the ulist anymore, and there are no errors propagated
from clear_record_extent_bits (just 0), but there are still some
unhandled cases. So here a negative value should be expected anyway.

> This is normally good enough, but sometimes we need the accurate byte
> number it freed/released.
> 
> Change it to return actually released/freed bytenr number instead of 0
> for success.
> And slightly modify related extent_changeset structure, since in btrfs
> one none-hole data extent won't be larger than 128M, so "unsigned int"
> is large enough for the use case.

> -	u64 bytes_changed;
> +	unsigned int bytes_changed;

> @@ -2875,6 +2875,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
>  				BTRFS_I(inode)->root->objectid,
>  				changeset.bytes_changed);
> +	ret = changeset.bytes_changed;

This relies on the 128M limit, which will fit to int when assigned. I'm
thinking about the signedness, it makes sense to use unsigned for
bytes_changed, but we also need the negative error returned. Probably
ok.

>  out:
>  	ulist_release(&changeset.range_changed);
>  	return ret;
