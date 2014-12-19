Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56608 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSFFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 00:05:25 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 1A19D3EE194
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:05:24 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1F036AC0218
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:05:23 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B6D11E08008
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:05:22 +0900 (JST)
Message-ID: <5493B1F8.2070106@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 14:04:56 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/6] btrfs-progs: fi usage, update manpage
References: <cover.1418912740.git.dsterba@suse.cz> <488c53a0e5e255f9504cfc2a029e7c1c72994f66.1418912740.git.dsterba@suse.cz>
In-Reply-To: <488c53a0e5e255f9504cfc2a029e7c1c72994f66.1418912740.git.dsterba@suse.cz>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 2014/12/18 23:27, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>   Documentation/btrfs-filesystem.txt | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> index a8f2972a0e1a..85a94eb52569 100644
> --- a/Documentation/btrfs-filesystem.txt
> +++ b/Documentation/btrfs-filesystem.txt
> @@ -123,6 +123,34 @@ Show or update the label of a filesystem.
>   If a newlabel optional argument is passed, the label is changed.
>   NOTE: the maximum allowable length shall be less than 256 chars
>   
> +*usage* [options] <path> [<path>...]::
> +Show detailed information about internal filesystem usage.

Options from "-b" to "-t" are the completely same as "btrfs fi df"'s ones.
So how about pointing the df's options as follows?

===============================================================================
...
+
`Options`
+
-T::::
Show data in tabular format
+
There are some option to set unit. See description of *df*'s options
from '-b' to '-t'.
+
If conflicting options are passed, the last one takes precedence.
...
===============================================================================

I consider it can prevent mistakes caused by further changes.

Thanks,
Satoru

> ++
> +`Options`
> ++
> +-b|--raw::::
> +raw numbers in bytes, without the 'B' suffix
> +-h::::
> +print human friendly numbers, base 1024, this is the default
> +-H::::
> +print human friendly numbers, base 1000
> +--iec::::
> +select the 1024 base for the following options, according to the IEC standard
> +--si::::
> +select the 1000 base for the following options, according to the SI standard
> +-k|--kbytes::::
> +show sizes in KiB, or kB with --si
> +-m|--mbytes::::
> +show sizes in MiB, or MB with --si
> +-g|--gbytes::::
> +show sizes in GiB, or GB with --si
> +-t|--tbytes::::
> +show sizes in TiB, or TB with --si
> +-T::::
> +show data in tabular format
> +
> +If conflicting options are passed, the last one takes precedence.
> +
>   EXIT STATUS
>   -----------
>   *btrfs filesystem* returns a zero exit status if it succeeds. Non zero is
> 

