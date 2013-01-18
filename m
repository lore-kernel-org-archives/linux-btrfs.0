Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab3ARMTT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 07:19:19 -0500
Date: Fri, 18 Jan 2013 13:19:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com, JBacik@fusionio.com, kitayama@cl.bb4u.ne.jp,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
Message-ID: <20130118121916.GI22785@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 08:42:46AM -0600, Mitch Harder wrote:
> [16028.160002] RAX: dead000000200200 RBX: ffff880000000000 RCX: 0000000000018e20
> [16028.160002] RDX: dead000000100100 RSI: 000000000000001b RDI: 000000000000001b

RAX: dead000000200200
RDX: dead000000100100

list_head poisons to mark deleted entries

> I've tried to trap the error with a BUG_ON prior to deleting the list,
> but my attempt isn't catching the error:
> 
> @@ -1769,6 +1769,7 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
>                 int ret;
> 
>                 root = list_entry(list.next, struct btrfs_root, root_list);
> +               BUG_ON(&root->root_list == NULL);

You're taking an address and comparing it to NULL? This works, but in
under very limited conditions :)

If root is not null, then the structure is valid, but the root_list hook
is not valid anymore, ie. an inconsistency.

david
