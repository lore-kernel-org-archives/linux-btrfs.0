Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:56146 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbJJQzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 12:55:08 -0400
From: covici@ccs.covici.com
To: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FHolger=5FHoffst=3Dc3=3Da4tte=3F=3D?=
	<holger.hoffstaette@googlemail.com>
cc: Lionel Bouton <lionel-subscription@bouton.name>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs says no errors, but booting gives lots of errors
In-reply-to: <5619385C.7040103@googlemail.com>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com> <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name> <5619385C.7040103@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Oct 2015 12:55:02 -0400
Message-ID: <16953.1444496102@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:

> On 10/10/15 17:46, Lionel Bouton wrote:
> > Le 10/10/2015 16:41, covici@ccs.covici.com a écrit :
> >> Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:
> >>
> >>> On 10/10/15 14:46, covici@ccs.covici.com wrote:
> >>>> Hi.  I am having lots of btrfs troubles  -- I am using a 4.1.9 kernel
> >>> Just FYI, both 4.1.9 and .10 have serious regressions in the network layer
> >>> that *will*  lock up the whole machine, either after a few minutes or a
> >>> few hours (when idle). Try 4.2.x or (also more btrfs fixes) or 4.1.8 (OK).
> > 
> > If I'm not mistaken as the OP uses Gentoo gentoo-sources-4.1.9-r1 should
> > have distribution patches for this (4.1 is LTS, not 4.2 so you might
> > want to prefer the 4.1 series).
> 
> Good point..after all I was the one who sent Mike a warning about that. :)
> Just saw that he had masked vanilla-.9/10, didn't see that he also added
> the required patch to gentoo-.9/10, since I use my own patches anyway.

But do you folks have any idea about my original question, this leads me
to think that btrfs is too new or something.


-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
