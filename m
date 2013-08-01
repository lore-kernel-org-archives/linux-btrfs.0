Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:22859 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3HAJnD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 05:43:03 -0400
Message-ID: <51FA2DA5.4030309@giantdisaster.de>
Date: Thu, 01 Aug 2013 11:43:01 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs-progs: add missing man page information for
 btrfsck
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 1 Aug 2013 13:35:25 +0800, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  man/btrfsck.8.in | 35 ++++++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
> index 5004ba0..6087c14 100644
> --- a/man/btrfsck.8.in
> +++ b/man/btrfsck.8.in
> @@ -1,11 +1,35 @@
>  .TH BTRFSCK 8
>  .SH NAME
> -btrfsck \- check a btrfs filesystem
> +btrfsck \- check and repair of a Btrfs filesystem
>  .SH SYNOPSIS
> -.B btrfsck \fI device\fP
> +.B btrfsck [\fIoptions\fP] \fI<device>\fP
>  .SH DESCRIPTION
> -\fBbtrfsck\fP is used to check a btrfs filesystem.
> -\fIdevice\fP is the device file where the filesystem is stored.
> +\fBbtrfsck\fP is used to check and optionally repair of a Btrfs filesystem. Now, it can only be run on an unmounted FS. Considering it is not well-tested
> +in real-life situations yet. if you have a broken Btrfs filesystem, btrfsck may not repair but cause aditional damages. \fI<device>\fP is the device file
> +where the filesystem is stored.
> +
> +\fIOptions\fP
> +.IP "\fB-s,--super \fI<superblock>\fP" 5
> +specify which superblock copy that you want to use.
> +.IP "\fB--repair\fP" 5
> +try to repair the filesystem.
> +.IP "\fB--init-csum-tree\fP" 5
> +create a new CRC tree.
> +.IP "\fB--init-extent-tree\fP" 5
> +create a new extent tree.
> +
> +.SH EXIT CODE
> +\fBbtrfsck\fR will return 0 exit code if no error happened.
> +Other exit code means some problems happened.
> +
> +.SH AUTHOR
> +Written by Shilong Wang and Wenruo Qu.

Please add the author Goldwyn Rodrigues.

You add text to the btrfsck manpage that Goldwyn Rodrigues has written
(according to git blame).

> +
> +.SH COPYRIGHT
> +Copyright \(co 2013 Fujitsu, Inc.
> +License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>.

Is GPLv3 tolerated in this area?	

> +.br
> +This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
>  .SH AVAILABILITY
>  .B btrfsck
>  is part of btrfs-progs. Btrfs is currently under heavy development,
> @@ -13,4 +37,5 @@ and not suitable for any uses other than benchmarking and review.
>  Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
>  further details.
>  .SH SEE ALSO
> -.BR mkfs.btrfs (8)
> +.BR mkfs.btrfs (8),
> +.BR btrfs (8)
> 

