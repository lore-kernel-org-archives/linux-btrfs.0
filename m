Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60504 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbcEYWF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 18:05:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b5gw8-0000YI-LM
	for linux-btrfs@vger.kernel.org; Thu, 26 May 2016 00:05:56 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 00:05:56 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 00:05:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Some ideas for improvements
Date: Wed, 25 May 2016 22:05:49 +0000 (UTC)
Message-ID: <pan$330ec$c3352766$623387a5$1e8558db@cox.net>
References: <45a47ee4db4cc92248f91f1d00e8ed03@www.centurion.link>
	<pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
	<CAD=QJKjfrtBN+nyhOK3mRxv2qkPMhx8Gf1MuuFqzkOYYv2RT=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Wed, 25 May 2016 16:36:13 -0400 as excerpted:

> On 25 May 2016 at 15:03, Duncan <1i5t5.duncan@cox.net> wrote:
>> Dmitry Katsubo posted on Wed, 25 May 2016 16:45:41 +0200 as excerpted:

>>> btrfs-restore [needs an o]ption that applies (y) to all questions
>>> (completely unattended recovery)
>>
>> That['s] a known sore spot that a lot of people have complained
>> about.

> I'm surprised no one has mentioned, in any of these discussions, what I
> believe is the standard method of providing this functionality:
> yes | btrfs-restore -options /dev/disk

Good point.

I didn't bring it up because while I've used btrfs restore a few times, 
my btrfs are all on relatively small SSD partitions, so I both needed 
less y's, and the total time per restore is a few minutes, not hours, so 
it wasn't a big deal.  As a result, while I know of yes, I didn't need to 
think about automation, and as I never used it, it didn't occur to me to 
suggest it for others.

Had I needed to use it, however, I expect I would have reached for yes, 
myself, so good point indeed, pointing out its use to others.  I just 
wish I'd thought of mentioning it, now.  =:^)

> And if you need it in your initrd on a Debian-like system, put the
> following in /etc/initramfs-tools/hooks/yes.hook :
> 
> #!/bin/sh
> 
> . /usr/share/initramfs-tools/hook-functions
> 
> if command -v /usr/bin/yes >/dev/null 2>&1; then
>     copy_exec /usr/bin/yes usr/bin/yes copy_exec /usr/bin/yes
>     usr/bin/yes
> fi
> 
> I haven't tested this, but it seems like it would do the trick.

FWIW, for those using a dracut-based initr* (which should be fedora/rh-
based distros as well as those like arch and gentoo, where it'd be an 
option, the recommended option in at least gentoo's case), it's a simple 
config file edit, with dracut taking care of the rest, including pulling 
in libraries for non-static binaries.  I've not used it for yes, but I've 
used it for a few other binaries.

I use the /etc/dracut.conf.d/* style of config here, and here's what I 
have in my specific installitems.conf file in that dir:

install_items+="
	/bin/most
	/bin/nano
"

(I don't have less, which dracut uses by default, on my system, 
preferring most.  And nano is a tiny but useful text editor that doesn't 
require the esoteric pre-use knowledge of something like vi/vim-minimal, 
tho I prefer the larger mc/mcedit in a less size constrained environment.)

Obviously I'd just need to include one more line there to pull in 
/bin/yes, if I wanted/needed it.  (Tho I've not checked, for all I know 
dracut pulls it in on its own or via some other module I'm already using.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

