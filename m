Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3A1C4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 21:56:36 -0500
Message-ID: <5105EA90.6000507@oracle.com>
Date: Mon, 28 Jan 2013 11:03:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: remove btrfsctl, btrfs-show and btrfs-vol
 from default build
References: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  This patch is much needed. thanks.

  Further, IMO the summary may provide a table of mapping of
  the original to its predecessor command-and-option so that
  - it will ensure we have taken care of all the original
  features in the new cli, and it will help to document
  for the onlooker.

  eg:
  old-command        replaced-by
   btrfsctl -D        btrfs subvol del
   ::
   ::

  (if this is already there somewhere providing a ref/copying
  here will help)

Thanks, Anand

On 06/09/2012 02:00 AM, Stefan Behrens wrote:
> Remove btrfsctl, btrfs-show and btrfs-vol from "all" target of Makefile.
>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>   Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index aaf1381..79e7a56 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -18,7 +18,7 @@ bindir = $(prefix)/bin
>   LIBS=-luuid
>   RESTORE_LIBS=-lz
>
> -progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
> +progs = mkfs.btrfs btrfs-debug-tree btrfsck \
>   	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
>   	btrfs-find-root btrfs-restore btrfstune
>
>
