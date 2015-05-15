Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33704 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423193AbbEOAdd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 20:33:33 -0400
Received: by iebgx4 with SMTP id gx4so76785644ieb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 17:33:32 -0700 (PDT)
Date: Thu, 14 May 2015 17:33:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: btrfs balance 4.0 regression?
Message-ID: <20150515003329.GA17120@mew>
References: <CA+5PVA5HhK07LHXcPxDV=JztgdRRa+2LsK7RJXDZ-Y+esAqX1g@mail.gmail.com>
 <pan$f2ed7$f0336ef0$1026d216$35cc450c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$f2ed7$f0336ef0$1026d216$35cc450c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 15, 2015 at 12:15:06AM +0000, Duncan wrote:
> Josh Boyer posted on Thu, 14 May 2015 08:43:25 -0400 as excerpted:
> 
> > Hi Omar and Chris,
> > 
> > We have a bug reported [1] against 4.0 saying that btrfs balance is
> > broken.  The reporter found a revert patch that Omar sent [2] to revert
> > commit 2f0810880.  Looking in Linus' latest tree, I don't see that
> > revert and I don't immediately see a patch to fix the issue Omar
> > reported either.
> > 
> > Do either of you know if this is still an issue?  If not, which commit
> > was it fixed by?
> > 
> > josh
> > 
> > [1] https://bugzilla.redhat.com/show_bug.cgi?id=1217191
> > [2] https://patchwork.kernel.org/patch/6238111/
> 
> Still an issue, officially as of dev comments a day or two ago, at least.

Yup, Chris says he has a proper fix but it hasn't hit the list yet.

> From various comments including from Chris Mason directly, the devs are 
> aware of it, but (from a non-dev list-regular perspective) there's a 
> seeming reluctance to simply apply the revert patch.  Not being a dev I 
> can't explain why tho I can speculate that the patch is logically correct 
> and simply triggers this other bug.  But further patches have yet to 
> appear.
> 
> Part of the problem may be a bit of confusion as some of the devs 
> evidently thought the revert patch fixed the problem and hadn't been 
> worrying about it until others pointed out the revert hadn't been applied 
> and the problem thus remained.
> 
> So as of now, the choice appears to be broken balance-convert with the 
> current code, or broken ext*-convert with that patch reverted.  Both 
> cases aren't entirely common, so I guess it's up to you which you want to 
> break ATM.

Actually, ext4 convert is broken anyways (with irrelevant output
elided):

# mkfs.ext4 -F /dev/vdb
# btrfs-convert /dev/vdb
# mount /dev/vdb /mnt
# btrfs fi df /mnt
Data, single: total=2.64GiB, used=163.70MiB		<- single
System, single: total=32.00MiB, used=16.00KiB		<- single
Metadata, single: total=1.33GiB, used=37.13MiB		<- single
GlobalReserve, single: total=16.00MiB, used=0.00B	<- single
# btrfs device add -f /dev/vdc /mnt
# btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt
Done, had to relocate 9 out of 9 chunks
# btrfs fi df /mnt
Data, single: total=832.00MiB, used=200.55MiB		<- still single
System, single: total=32.00MiB, used=16.00KiB		<- still single
Metadata, single: total=256.00MiB, used=368.00KiB	<- still single
GlobalReserve, single: total=16.00MiB, used=0.00B	<- still single

So the balance succeeds unlike before the commit that caused the
regression, but the profile is still single, which defeats the purpose.

-- 
Omar
