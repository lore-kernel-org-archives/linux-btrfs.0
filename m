Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57398 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbeEPPJR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 11:09:17 -0400
Date: Wed, 16 May 2018 17:09:08 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: balance: add args info during start and
 resume
Message-ID: <20180516150908.l7nufyibeq564qan@angband.pl>
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-3-anand.jain@oracle.com>
 <81c9b168-1e51-2940-b7dc-fb753852154a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <81c9b168-1e51-2940-b7dc-fb753852154a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 10:57:57AM +0300, Nikolay Borisov wrote:
> On 16.05.2018 05:51, Anand Jain wrote:
> > Balance args info is an important information to be reviewed for the
> > system audit. So this patch adds it to the kernel log.
> > 
> > Example:
> > 
> > -> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs
> > 
> >  kernel: BTRFS info (device sdb): balance: start data profiles=raid1|single convert=raid5 metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
> > 
> > -> btrfs bal start -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs
> > 
> >  kernel: BTRFS info (device sdb): balance: start data profiles=raid5 convert=single metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Why can't this code be part of progs, the bctl which you are parsing is
> constructed from the arguments passed from users space? I think you are
> adding way too much string parsing code to the kernel and this is never
> a good sign, since it's very easy to trip.

progs are not the only way to start a balance, they're merely the most
widespread one.  For example, Hans van Kranenburg has some smarter scripts
among his tools -- currently only of "example" quality, but quite useful
already.  "balance_least_used" works in greedy order (least used first) with
nice verbose output.  It's not unlikely he or someone else improves this
further.  Thus, I really think the logging should be kernel side.

On the other hand, the string producing (not parsing) code is so repetitive
that it indeed could use some refactoring.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀ 
