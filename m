Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59752 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756331AbcIHRik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2016 13:38:40 -0400
Received: from tux.wizards.de (p579D0EDA.dip0.t-ipconnect.de [87.157.14.218])
        by mail02.iobjects.de (Postfix) with ESMTPSA id ACE3B4160C8C
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2016 19:38:37 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 4CA7111C01EC
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2016 19:38:37 +0200 (CEST)
Subject: Re: Finding only non-snapshots via btrfs subvol list
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5790E255.50806@applied-asynchrony.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57D1A21D.9020306@applied-asynchrony.com>
Date: Thu, 8 Sep 2016 19:38:37 +0200
MIME-Version: 1.0
In-Reply-To: <5790E255.50806@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/16 16:55, Holger Hoffstätte wrote:
> I'm trying to find non-snapshots, i.e. 'top-level' subvolumes in a
> filesystem and this seems harder than it IMHO should be.
> 
> The fs is just like:
> 
> /mnt/stuff
>  subvolA
>  subvolA-date1
>  subvolA-date2
>  subvolB
>  subvolB-date1
>  subvolB-date2
> ..
> 
> All I want are the subvol{A,B} *without* the snapshots, but so
> far I haven't been able to accomplish this easily with "subvol list"
> and its options. -s lists only snapshots, but what I want is the
> exact opposite.

This question received a deafening lack of feedback, so I just took
a swing at this and apparently hit something.

When you have a set of subvols and snapshots like so:

$./btrfs subvolume list /t/btrfs
ID 257 gen 13 top level 5 path a
ID 258 gen 16 top level 5 path b
ID 259 gen 15 top level 5 path c
ID 260 gen 11 top level 5 path a1
ID 261 gen 12 top level 5 path a2
ID 263 gen 14 top level 5 path b1
ID 264 gen 15 top level 5 path c1
ID 265 gen 16 top level 5 path b2

where a,b,c are subvolumes and ?{1,2,3} are snapshots, you can now do:

$./btrfs subvolume list -P /t/btrfs
ID 257 gen 13 top level 5 path a
ID 258 gen 16 top level 5 path b
ID 259 gen 15 top level 5 path c

Is this of interest? I find it useful to iterate over all parent
subvols (though you'll still need cut or awk to get only the name)
without accidentally hitting the snapshots, or relying on fragile inhouse
naming conventions.

The -P was the only meaningful letter left (P for Parent). I first used
-S (for grown-up -s ;) but that was already used for matching getopt
on --sort. If -S is deemed better I can reroute that to -Z or something,
since it's unused in short form.

The patch is surprisingly small and was quite easy to write. Nice!

cheers
Holger

