Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:60073 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959Ab3BMNB1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 08:01:27 -0500
Message-ID: <511B8EA6.9050806@jan-o-sch.net>
Date: Wed, 13 Feb 2013 14:01:26 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Arne Jansen <sensille@gmx.net>, shyam.btrfs@gmail.com
Subject: Re: [PATCH] Btrfs: fix crash in log replay with qgroups enabled
References: <1360754401-24807-1-git-send-email-sensille@gmx.net>
In-Reply-To: <1360754401-24807-1-git-send-email-sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, February 13, 2013 at 12:20 (+0100), Arne Jansen wrote:
> When replaying a log tree with qgroups enabled, tree_mod_log_rewind does a
> sanity-check of the number of items against the maximum possible number.
> It calculates that number with the nodesize of fs_root. Unfortunately
> fs_root is not yet set at this stage. So instead use the nodesize from
> tree_root, which is already initialized.
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/ctree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index eea5da7..6eff0fa 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1222,7 +1222,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  
>  	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
>  	WARN_ON(btrfs_header_nritems(eb_rewin) >
> -		BTRFS_NODEPTRS_PER_BLOCK(fs_info->fs_root));
> +		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
>  
>  	return eb_rewin;
>  }
> 

Chris, please send this for the next patch round for 3.8, optionally with cc for
stable (the check was added in 3.6).

Thanks,
-Jan
