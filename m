Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38366 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3KNN4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 08:56:20 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id AE3149A0744
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 06:56:19 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1384435845-8493-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>
References: <1384435845-8493-1-git-send-email-dsterba@suse.cz>
Message-ID: <20131114135613.3802.45079@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: mkfs: extend -O syntax to disable features
Date: Thu, 14 Nov 2013 08:56:13 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-11-14 08:30:45)
> A way of disabling features that are on by default in case it's not
> wanted, eg. due to lack of support in the used kernel.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  mkfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index cd0af9ef8b4f..f825e1b6bc2d 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1168,7 +1168,11 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
>         int found = 0;
>  
>         for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
> -               if (!strcmp(mkfs_features[i].name, name)) {
> +               if (name[0] == '^' &&
> +                       !strcmp(mkfs_features[i].name, name + 1)) {
> +                       *flags &= ~ mkfs_features[i].flag;
> +                       found = 1;
> +               } else if (!strcmp(mkfs_features[i].name, name)) {
>                         *flags |= mkfs_features[i].flag;
>                         found = 1;
>                 }

Perfect, I was going to do this today so I can enable extrefs.

-chris
