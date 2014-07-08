Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55321 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaGHUTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 16:19:10 -0400
Received: by mail-oa0-f51.google.com with SMTP id j17so7112453oag.10
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jul 2014 13:19:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMqPLXUHJ8Gtc9r9cNVaaijp6VcEy_nLoeFxSWR_2ajevi+jcg@mail.gmail.com>
References: <btrfswiki.52f1178eb44ca2.65163100@btrfs.wiki.kernel.org>
	<CAMqPLXUHJ8Gtc9r9cNVaaijp6VcEy_nLoeFxSWR_2ajevi+jcg@mail.gmail.com>
Date: Tue, 8 Jul 2014 22:19:08 +0200
Message-ID: <CAK_tfuY3cnPyrsTVvKVCcDsSC1SvchKmyc6tq7T8=+ErRhnbFQ@mail.gmail.com>
Subject: Fwd: btrfs Wiki account request
From: Sjon Hortensius <sjon@hortensius.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wrote a simple alternative for a script that is currently on the
btrfs wiki (for showing quotas) in bash instead of Python. I have
attempted to add this to the page but after entering the captcha 15
times my account was rejected because of a missing bio. Maybe someone
can add this to https://btrfs.wiki.kernel.org/index.php/Quota_support:

#!/bin/bash

[[ ! -d $1 ]] && { echo Please pass mountpoint as first argument >&2 ;
exit 1 ; }

while read x i x g x x l x p
do
    volName[i]=$p
done < <(btrfs subvolume list $1)

while read g r e
do
    [[ -z $name ]] && echo -e "subvol\tqgroup\ttotal\tunshared"
    group=${g##*/}
    [[ ! -z ${volName[group]} ]] && name=${volName[group]} || name='(unknown)'
    echo $name $g `numfmt --to=iec $r` `numfmt --to=iec $e`
done < <(btrfs qgroup show $1 | tail -n+3) | column -t

Thanks,
Sjon

On Tue, Feb 4, 2014 at 5:38 PM, MediaWiki Mail <wikiadmin@kernel.org> wrote:
> Sorry, your request for an account "Sjon Hortensius" has been rejected on btrfs Wiki.
>
> try again with a useful bio
>
> There may be contact lists on site that you can use if you want to know more about user account policy.
