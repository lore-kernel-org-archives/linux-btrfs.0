Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47313 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaDDS5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 14:57:43 -0400
Date: Fri, 4 Apr 2014 11:46:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140404184620.GA12124@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 04:29:35PM +0800, Qu Wenruo wrote:
> Convert man page for btrfs-zero-log
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/Makefile           |  2 +-
>  Documentation/btrfs-zero-log.txt | 39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/btrfs-zero-log.txt
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index e002d53..de06629 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -11,7 +11,7 @@ MAN8_TXT += btrfs-image.txt
>  MAN8_TXT += btrfs-map-logical.txt
>  MAN8_TXT += btrfs-show-super.txt
>  MAN8_TXT += btrfstune.txt
> -#MAN8_TXT += btrfs-zero-log.txt
> +MAN8_TXT += btrfs-zero-log.txt
>  #MAN8_TXT += fsck.btrfs.txt
>  #MAN8_TXT += mkfs.btrfs.txt
>  
> diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
> new file mode 100644
> index 0000000..e3041fa
> --- /dev/null
> +++ b/Documentation/btrfs-zero-log.txt
> @@ -0,0 +1,39 @@
> +btrfs-zero-log(8)
> +=================
> +
> +NAME
> +----
> +btrfs-zero-log - clear out log tree
> +
> +SYNOPSIS
> +--------
> +'btrfs-zero-log' <dev>
> +
> +DESCRIPTION
> +-----------
> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
> +allow you to mount the filesystem again.
> +
> +The common case where this happens has been fixed a long time ago,
> +so it is unlikely that you will see this particular problem.

A note on this one: this can happen if your SSD rites things in the
wrong order or potentially writes garbage when power is lost, or before
locking up.
I hit this problem about 10 times and it wasn't a btrfs bug, just the
drive doing bad things.

I had debian add this to the initramfs initrd by default so that someone
can recover their root filesystem with this command if it won't mount.

What got fixed is the kernel used to oops and crash, and now it gives a
nice "can't mount" error message.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
