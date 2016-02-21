Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34609 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbcBUA5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 19:57:25 -0500
Subject: Re: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
To: clm@fb.com, joe@perches.com
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
 <1456016178-4560-1-git-send-email-tsimonq2@ubuntu.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Simon Quigley <tsimonq2@ubuntu.com>
Message-ID: <56C90B73.7030702@ubuntu.com>
Date: Sat, 20 Feb 2016 18:57:23 -0600
MIME-Version: 1.0
In-Reply-To: <1456016178-4560-1-git-send-email-tsimonq2@ubuntu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Better?

On 02/20/2016 06:56 PM, Simon Quigley wrote:
> checkpatch.pl reported a warning of over 80 characters on line 1833
>
> Adjusted to put &extref and &offset on a different line
>
> Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
> ---
>   fs/btrfs/backref.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index f6dac40..956fffa 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1830,8 +1830,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>   	unsigned long ptr;
>
>   	while (1) {
> -		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
> -					    &offset);
> +		ret = btrfs_find_one_extref(fs_root, inum, offset, path,
> +							&extref, &offset);
>   		if (ret < 0)
>   			break;
>   		if (ret) {
>
