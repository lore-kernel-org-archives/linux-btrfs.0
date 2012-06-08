Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37909 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2FHTVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 15:21:52 -0400
Received: by yenm10 with SMTP id m10so1532586yen.19
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jun 2012 12:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339182766-15292-4-git-send-email-kreijack@inwind.it>
References: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
	<1339182766-15292-4-git-send-email-kreijack@inwind.it>
Date: Fri, 8 Jun 2012 15:21:52 -0400
Message-ID: <CALJXSJo9nqC+ybB7bk0dZv12mg=NMG4Oiv52Y02yxCUcek1=_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add btrfs filesystem info man page.
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What kind of "info" does it give? This is really unhelpful in a man
page, it just tells the obvious.

On Fri, Jun 8, 2012 at 3:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>
> Update the man page to document the "btrfs filesystem info <path>"
> command.
> ---
>  man/btrfs.8.in |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index be478e0..6d96bf7 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
>  .PP
> +\fBbtrfs\fP \fBfilesystem info\fP\fI <path>\fP
> +.PP
>  \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
>  .PP
>  \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
> @@ -154,6 +156,12 @@ The start position and the number of bytes to deframention can be specified by \
>  NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't
>  use it if you use snapshots, have de-duplicated your data or made copies with
>  \fBcp --reflink\fP.
> +.TP
> +
> +\fBfilesystem info\fP \fI<path>\fR
> +Get filesystem info.
> +.TP
> +
>  \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
>  List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
>  .TP
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
