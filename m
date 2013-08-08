Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960Ab3HHNjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 09:39:04 -0400
Date: Thu, 8 Aug 2013 15:39:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 3/7] btrfs: cleanup: mark
 'btrfs_write_and_wait_marked_extents' as static
Message-ID: <20130808133902.GU5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-4-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375911803-17318-4-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 12:43:19AM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by uselex.rb:
> > btrfs_write_and_wait_marked_extents: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/transaction.o fs/btrfs/built-in.o
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  fs/btrfs/transaction.c | 4 ++--
>  fs/btrfs/transaction.h | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index d58cce7..ff891d2 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -837,8 +837,8 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
>   * them in one of two extent_io trees.  This is used to make sure all of
>   * those extents are on disk for transaction or log commit
>   */
> -int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
> -				struct extent_io_tree *dirty_pages, int mark)
> +static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
> +					       struct extent_io_tree *dirty_pages, int mark)

You may want to run the output through checkpatch.pl and fix obvious
style violations (line too long).

david
