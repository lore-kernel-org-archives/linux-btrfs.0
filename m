Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34439 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbbEQIqo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 04:46:44 -0400
Received: by pabru16 with SMTP id ru16so101378723pab.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 01:46:44 -0700 (PDT)
Date: Sun, 17 May 2015 01:46:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: btrfs balance 4.0 regression?
Message-ID: <20150517084642.GA14149@mew>
References: <CA+5PVA5HhK07LHXcPxDV=JztgdRRa+2LsK7RJXDZ-Y+esAqX1g@mail.gmail.com>
 <pan$f2ed7$f0336ef0$1026d216$35cc450c@cox.net>
 <20150515003329.GA17120@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150515003329.GA17120@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 05:33:29PM -0700, Omar Sandoval wrote:
> On Fri, May 15, 2015 at 12:15:06AM +0000, Duncan wrote:
> > Josh Boyer posted on Thu, 14 May 2015 08:43:25 -0400 as excerpted:
> > 
> > > Hi Omar and Chris,
> > > 
> > > We have a bug reported [1] against 4.0 saying that btrfs balance is
> > > broken.  The reporter found a revert patch that Omar sent [2] to revert
> > > commit 2f0810880.  Looking in Linus' latest tree, I don't see that
> > > revert and I don't immediately see a patch to fix the issue Omar
> > > reported either.
> > > 
> > > Do either of you know if this is still an issue?  If not, which commit
> > > was it fixed by?
> > > 
> > > josh
> > > 
> > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=1217191
> > > [2] https://patchwork.kernel.org/patch/6238111/
> > 
> > Still an issue, officially as of dev comments a day or two ago, at least.
> 
> Yup, Chris says he has a proper fix but it hasn't hit the list yet.
> 
> > From various comments including from Chris Mason directly, the devs are 
> > aware of it, but (from a non-dev list-regular perspective) there's a 
> > seeming reluctance to simply apply the revert patch.  Not being a dev I 
> > can't explain why tho I can speculate that the patch is logically correct 
> > and simply triggers this other bug.  But further patches have yet to 
> > appear.
> > 
> > Part of the problem may be a bit of confusion as some of the devs 
> > evidently thought the revert patch fixed the problem and hadn't been 
> > worrying about it until others pointed out the revert hadn't been applied 
> > and the problem thus remained.
> > 
> > So as of now, the choice appears to be broken balance-convert with the 
> > current code, or broken ext*-convert with that patch reverted.  Both 
> > cases aren't entirely common, so I guess it's up to you which you want to 
> > break ATM.
> 
> Actually, ext4 convert is broken anyways (with irrelevant output
> elided):

(I realize that I was being a bit too alarmist here. Reposting a message
from another thread clarifying.)

"""
Just to clarify, reverting 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e does
not break ext4 conversion. If you revert it, you can btrfs-convert, do a
btrfs balance to finalize the conversion, then do another btrfs balance
-dconvert=... -mconvert=... to convert the profile. I should have been
clearer in that other thread: conversion from ext4 to Btrfs works, its
just that the commit that caused the regression did not actually
accomplish what it set out to do: allow converting the data/metadata
profile of a freshly btrfs-converted ext4 filesystem.
"""


-- 
Omar
