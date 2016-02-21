Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:43267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751460AbcBUXxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 18:53:07 -0500
Message-ID: <1456098784.31061.10.camel@perches.com>
Subject: Re: [PATCH] Btrfs: ctree: added lines after variable declarations
From: Joe Perches <joe@perches.com>
To: Philippe Loctaux <phil@philippeloctaux.com>, clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Feb 2016 15:53:04 -0800
In-Reply-To: <1456098390-9859-1-git-send-email-phil@philippeloctaux.com>
References: <1456098390-9859-1-git-send-email-phil@philippeloctaux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2016-02-22 at 00:46 +0100, Philippe Loctaux wrote:
> Added lines after variable declarations, fixing 22 checkpatch warnings.
[]
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
[]
> @@ -4592,6 +4610,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
>  			      data_end, old_data_start + new_size - data_end);
>  	} else {
>  		struct btrfs_disk_key disk_key;
> +
>  		u64 offset;

Overzealous here.
No additional blank line required.

