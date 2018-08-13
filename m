Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729029AbeHMUVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 16:21:20 -0400
Date: Mon, 13 Aug 2018 19:38:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
Message-ID: <20180813173800.GB24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 02:25:24PM +0900, Misono Tomohiro wrote:
> There are two members in struct btrfs_root which indicate root's
> objectid: ->objectid and ->root_key.objectid.
> 
> They are both set to the same value in __setup_root():
>   static void __setup_root(struct btrfs_root *root,
>                            struct btrfs_fs_info *fs_info,
>                            u64 objectid)
>   {
>     ...
>     root->objectid = objectid;
>     ...
>     root->root_key.objectid = objecitd;
>     ...
>   }
> and not changed to other value after initialization.
> 
> grep in btrfs directory shows both are used in many places:
>   $ grep -rI "root->root_key.objectid" | wc -l
>   133
>   $ grep -rI "root->objectid" | wc -l
>   55
>  (4.17, inc. some noise)
> 
> It is confusing to have two similar variable names and it seems
> that there is no rule about which should be used in a certain case.
> 
> Since ->root_key itself is needed for tree reloc tree, let's remove
> 'objecitd' member and unify code to use ->root_key.objectid in all places.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

If you have further updates, please base them on top of this patch as it
looks good to me in its current form.
