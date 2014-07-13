Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47126 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGMOtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 10:49:41 -0400
Date: Sun, 13 Jul 2014 07:49:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Sjon Hortensius <sjon@hortensius.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140713144932.GK10641@merlins.org>
References: <btrfswiki.52f1178eb44ca2.65163100@btrfs.wiki.kernel.org>
 <CAMqPLXUHJ8Gtc9r9cNVaaijp6VcEy_nLoeFxSWR_2ajevi+jcg@mail.gmail.com>
 <CAK_tfuY3cnPyrsTVvKVCcDsSC1SvchKmyc6tq7T8=+ErRhnbFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK_tfuY3cnPyrsTVvKVCcDsSC1SvchKmyc6tq7T8=+ErRhnbFQ@mail.gmail.com>
Subject: Re: Fwd: btrfs Wiki account request
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 08, 2014 at 10:19:08PM +0200, Sjon Hortensius wrote:
> I wrote a simple alternative for a script that is currently on the
> btrfs wiki (for showing quotas) in bash instead of Python. I have
> attempted to add this to the page but after entering the captcha 15
> times my account was rejected because of a missing bio. Maybe someone
> can add this to https://btrfs.wiki.kernel.org/index.php/Quota_support:
> 
> #!/bin/bash
> 
> [[ ! -d $1 ]] && { echo Please pass mountpoint as first argument >&2 ;
> exit 1 ; }
> 
> while read x i x g x x l x p
> do
>     volName[i]=$p
> done < <(btrfs subvolume list $1)
> 
> while read g r e
> do
>     [[ -z $name ]] && echo -e "subvol\tqgroup\ttotal\tunshared"
>     group=${g##*/}
>     [[ ! -z ${volName[group]} ]] && name=${volName[group]} || name='(unknown)'
>     echo $name $g `numfmt --to=iec $r` `numfmt --to=iec $e`
> done < <(btrfs qgroup show $1 | tail -n+3) | column -t

I added it to the page.

Best,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
