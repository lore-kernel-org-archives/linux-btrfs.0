Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:37224 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752612AbcBUAKf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 19:10:35 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave01.hostedemail.com (Postfix) with ESMTP id DC1575DBE4
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 00:02:35 +0000 (UTC)
Message-ID: <1456012950.4031.17.camel@perches.com>
Subject: Re: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
 characters
From: Joe Perches <joe@perches.com>
To: Simon Quigley <tsimonq2@ubuntu.com>, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 20 Feb 2016 16:02:30 -0800
In-Reply-To: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2016-02-20 at 12:17 -0600, Simon Quigley wrote:
> checkpatch.pl reported a warning of over 80 characters on line 1833
[]
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
[]
> @@ -1830,7 +1830,11 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>  	unsigned long ptr;
>  
>  	while (1) {
> -		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
> +		ret = btrfs_find_one_extref(fs_root,
> +						inum,
> +						offset,
> +						path,
> +						&extref,
>  					    &offset);

I think this is poor because all the arguments aren't aligned.

It'd be nicer like:

		ret = btrfs_find_one_extref(fs_root, inum, offset, path,
					    &extref, &offset);

