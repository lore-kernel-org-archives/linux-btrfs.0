Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37177 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaA0VVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 16:21:54 -0500
Received: by mail-qa0-f50.google.com with SMTP id cm18so7968210qab.37
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 13:21:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
References: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
From: =?ISO-8859-2?Q?Daniel_Cegie=B3ka?= <daniel.cegielka@gmail.com>
Date: Mon, 27 Jan 2014 22:21:32 +0100
Message-ID: <CAPLrYES8sRMKPpDcAJC+cxj4D3osHz-x1x_RRqpECbvhNB6m2A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: update INSTALL file
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-22 Anand Jain <anand.jain@oracle.com>:
> with the changes that has happened since last time it was updated
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  INSTALL |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/INSTALL b/INSTALL
> index 8ead607..a86878a 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -12,7 +12,8 @@ complete:
>  modprobe libcrc32c
>  insmod btrfs.ko
>
> -The Btrfs utility programs require libuuid to build.  This can be found
> +The Btrfs utility programs (btrfs-progs) require libattr zlib libacl
> +e2fsprogs libblkid lzo2 to build.  This can be found
>  in the e2fsprogs sources, and is usually available as libuuid or
>  e2fsprogs-devel from various distros.

Which version of libblkid should we use? From e2fsprogs or from util-linux?

libattr/libacl: these libraries are not necessary - you need it only to convert.

Daniel
