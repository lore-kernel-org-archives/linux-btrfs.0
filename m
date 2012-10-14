Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49816 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2JNJDl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 05:03:41 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2502872eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2012 02:03:40 -0700 (PDT)
Message-ID: <507A8000.1010307@gmail.com>
Date: Sun, 14 Oct 2012 11:04:00 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Btrfs-progs: add mount-option command man page
References: <50778C1D.4060807@jp.fujitsu.com> <50778D7D.4080803@jp.fujitsu.com>
In-Reply-To: <50778D7D.4080803@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-12 05:24, Hidetoshi Seto wrote:
> Add mount-option command man page.
> 
> Signed-off-by: Hidetoshi Seto<seto.hidetoshi@jp.fujitsu.com>
> ---
>   man/btrfs.8.in |   25 +++++++++++++++++++++++++
>   1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 4b0a9f9..85d5030 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -52,6 +52,12 @@ btrfs \- control a btrfs filesystem
>   \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
>   [-Pv] \fI<logical>\fP \fI<path>\fP
>   .PP
> +\fBbtrfs\fP \fBmount-option set\fP \fI[[<+/-/=><option>,...]...]\fP \fI<device>\fP
> +.PP
> +\fBbtrfs\fP \fBmount-option get\fP \fI<device>\fP
> +.PP
> +\fBbtrfs\fP \fBmount-option clear\fP \fI<device>\fP
> +.PP
>   \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
>   .PP
>   \fBbtrfs\fP \fB<command>  \-\-help \fP\fI\fP
> @@ -319,6 +325,25 @@ skip the path resolving and print the inodes instead
>   .IP -v 5
>   verbose mode. print count of returned paths and all ioctl() return values
>   .RE
> +.TP
> +
> +\fBmount-option set\fP \fI[<+/-/=><option>,...]...]\fP \fI<device>\fP
> +With some operators \fB+\fP,\fB-\fP,\fB=\fP and some options,
> +set default mount options to the \fI<device>\fP.
> +These \fB+\fP,\fB-\fP,\fB=\fP operators mean like \fBchmod\fP operators.
> +The operator \fB+\fP causes the selected mount options to be added to existing
> +default mount options of the \fI<device>\fP; \fB-\fP causes them to be removed;
> +and \fB=\fP causes them to be added and causes unmentioned options to be removed.
> +Without options, print default mount options of the \fI<device>\fR.
> +.TP


Please list all the available options here; otherwise I suggest to list
them in the help of "btrfs mount-option" I think that it would be more
simple ...

> +
> +\fBmount-option get\fP \fI<device>\fP
> +Print default mount options of the \fI<device>\fR.
> +.TP
> +
> +\fBmount-option clear\fP \fI<device>\fP
> +Clear default mount options of the \fI<device>\fR.
> +.TP
> 
>   .SH EXIT STATUS
>   \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in

