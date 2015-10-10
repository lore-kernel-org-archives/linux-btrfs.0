Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:40058 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbJJQpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 12:45:55 -0400
From: covici@ccs.covici.com
To: Lionel Bouton <lionel-subscription@bouton.name>
cc: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FHolger=5FHoffst=3Dc3=3Da4tte=3F=3D?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs says no errors, but booting gives lots of errors
In-reply-to: <561932EF.2090005@bouton.name>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com> <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Oct 2015 12:45:50 -0400
Message-ID: <16632.1444495550@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Lionel Bouton <lionel-subscription@bouton.name> wrote:

> Le 10/10/2015 16:41, covici@ccs.covici.com a écrit :
> > Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:
> >
> >> On 10/10/15 14:46, covici@ccs.covici.com wrote:
> >>> Hi.  I am having lots of btrfs troubles  -- I am using a 4.1.9 kernel
> >> Just FYI, both 4.1.9 and .10 have serious regressions in the network layer
> >> that *will*  lock up the whole machine, either after a few minutes or a
> >> few hours (when idle). Try 4.2.x or (also more btrfs fixes) or 4.1.8 (OK).
> 
> If I'm not mistaken as the OP uses Gentoo gentoo-sources-4.1.9-r1 should
> have distribution patches for this (4.1 is LTS, not 4.2 so you might
> want to prefer the 4.1 series).

I do use those patches.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
