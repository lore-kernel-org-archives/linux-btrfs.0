Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:37433 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbABD14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jan 2015 22:27:56 -0500
Received: by mail-yh0-f47.google.com with SMTP id f73so8713214yha.34
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jan 2015 19:27:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <20141229160712.GK6490@twin.jikos.cz>
	<1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Date: Thu, 1 Jan 2015 20:27:55 -0700
Message-ID: <CAJCQCtSeguD-oC9ikBc-Mn6_xeu2f-EbfLSFLpSOKgVsEs-T5g@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs-progs: Documentation: add T/P/E description for
 resize cmd
From: Chris Murphy <lists@colorremedies.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        takeuchi_satoru@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 29, 2014 at 6:52 PM, Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> changelog
>         v1->v2:
>                 s/\'E\'(EiB)/or \'E\'(EiB)/ as suggested by Satoru, thanks.
>         v2->v3:
>                 replace confusing format 'K'(KiB) etc. Thanks, David.
> ---
>  Documentation/btrfs-filesystem.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> index a8f2972..96c4420 100644
> --- a/Documentation/btrfs-filesystem.txt
> +++ b/Documentation/btrfs-filesystem.txt
> @@ -102,8 +102,9 @@ If the prefix + or - is present the size is increased or decreased
>  by the quantity <size>.
>  If no units are specified, the unit of the <size> parameter defaults to
>  bytes. Optionally, the size parameter may be suffixed by one of the following
> -units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
> -respectively.
> +units designators: \'K\', \'M\', \'G\', \'T\', \'P\', or \'E\', which represent
> +KiB, MiB, GiB, TiB, PiB, or EiB, respectively.
> +
>  +
>  If \'max' is passed, the filesystem will occupy all available space on the
>  device devid.

Small problem with the rendering of this commit
d4ef1a06f8be623ae94e4d498c306e8dd1605bef, when I use 'man btrfs
filesystem' the above portion looks like this:

 'K', 'M', 'G', 'T', 'P', or 'E\',

I'm not sure why there's a trailing slash after the E.

Separately, for -t option, it reads:
For <start>, <len>, <size> it is possible to append a suffix like k
for 1 KBytes, m for 1 MBytes...

So there's a reference of small k and m there, but then later
references for capitalized KMGTPE, so maybe the reference could be
more like e.g. LVM where it's described as [bBsSkKmMgGtTpPeE] and just
omit the sS for sectors since this isn't supported.


-- 
Chris Murphy
