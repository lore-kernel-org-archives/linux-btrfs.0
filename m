Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37276 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933062AbcIFWZC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 18:25:02 -0400
Received: by mail-wm0-f45.google.com with SMTP id w12so565854wmf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 15:25:01 -0700 (PDT)
References: <pan$8ec2c$ff524e2$2c7a6f41$1fe67610@cox.net>
Subject: Re: btrfs send extremely slow (almost stuck)
To: 1i5t5.duncan@cox.net, linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <0d49b31c-4cab-f36e-dfec-a414a2ed175f@googlemail.com>
Date: Wed, 7 Sep 2016 00:24:59 +0200
MIME-Version: 1.0
In-Reply-To: <pan$8ec2c$ff524e2$2c7a6f41$1fe67610@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote on Mon, 05 Sep 2016 19:14:30 -0700: 
> I had something very similar happen here a few weeks ago, except with my 
> firefox profile dir (I don't run thunderbird, preferring claws-mail, but 
> I do run firefox as my browser).

Indeed, I also note Firefox doing a lot of IO especially if session recovery is enabled,
so I can totally imagine this causing similar issues... 

> My use-case does neither snapshots nor send/receive, however, so it was 
> just the single root subvolume (5).  But there was supposedly a file in 
> that dir according to bash's tab-completion, that would neither list, nor 
> rm, which meant the dir couldn't rm -r either.  (Interestingly enough, rm 
> -i asked if I wanted to rm "weird file" whatever, and weird it indeed was!
> )

Sadly, for me there is / was no file at all "visible", neither via tab nor via 'rm -i'. 

> So I immediately copied all the normal files to a new dir, and deleted 
> the normal files from the problem dir, leaving only the weird one.
> Then I renamed the problem dir in ordered to be able to rename the new 
> dir (with the good files) back to the name firefox expected.

That was exactly my "backup plan" I applied yesterday. In my case, luckily,
I even had a full backup of the profile just a few hours old, so I just took that
to replace the folder with a fresh one after renaming it. 

> Then I decided to see what I could do with the renamed dir.  I believe I 
> rebooted (or umount/mount cycled the filesystem) as well.  I think I had 
> to use the magic-sysrq m/remount-ro key as it refused to umount even from 
> systemd emergency mode.  But here's the interesting part.  At least after 
> the rename and a reboot, it *DID* let me delete (using mc) the dir!  I 
> honestly didn't expect it'd let me, but it did.

For me all the shutdowns went fine (the problem must / may have been present for weeks, 
I only noticed now that btrfs send finally did something - and errored out) 
- and the problem, sadly, was not fixed after any reboot. 
I guess after all for me it was corruption on the directory itself
(or rather its isize), 
while for you it was some other sort of metadata corruption causing 
a "weirdly behaving" file. 

> The difference, however, is that I didn't have any snapshots/subvolumes 
> or other reflinks to the "weird" file, only the one normal hardlink.  So 
> even if it's the same thing, I'm not sure if it'll work for you given the 
> multiple snapshot reflinks to the file, as it did for me with just the 
> one.

I did at least try to delete all snapshots which could reference that file - did not help. 
I also tried running 'btrfs defrag' on that folder, which should have broken up any reflinks, 
this also did not help. 

But luckily (as you can see from my other mail) two "btrfs check --repair" iterations finally
fixed my issue. I hope the experts can figure out something from my uploaded debug info
to prevent such things in the future. 

Thanks a lot in any case for your experience report! 

I hope my "repair experience" from my other mail made from my user's perspective may at some point
of time also be of help to you (even though, I hope, you'll never need it). 

Cheers and thanks again, 
	Oliver
