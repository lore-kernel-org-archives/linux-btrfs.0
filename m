Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55555 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754516AbdKANbh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 09:31:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e9t75-0006zL-O2
        for linux-btrfs@vger.kernel.org; Wed, 01 Nov 2017 14:31:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: defragmenting best practice?
Date: Wed, 1 Nov 2017 13:31:06 +0000 (UTC)
Message-ID: <pan$a12aa$cc98be99$a32e15b5$d57e6497@cox.net>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
        <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
        <59BBDFA6.4020500@sarach.com.pl>
        <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
        <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
        <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
        <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
        <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave posted on Tue, 31 Oct 2017 17:47:54 -0400 as excerpted:

> 6. Make sure Firefox is running in multi-process mode. (Duncan's
> instructions, while greatly appreciated and very useful, left me
> slightly confused about pulseaudio's compatibility with multi-process
> mode.)

Just to clarify:

There's no problem with native pulseaudio and firefox multi-process 
mode.  As that's what most people will be using, and what firefox 
upstream ships for, chances are very high that you're just fine there, 
tho there's some small chance you have some other problem.

My specific problem was that I do *NOT* have pulseaudio installed here, 
as I've never found I needed it and it adds more complication to my 
configuration than the limited benefit I'd get out of it justifies.  
Straight alsa has been fine for me.

(Explanatory note: Being on gentoo/~amd64, aka testing, I do a lot more 
updating than stable users, and because it's gentoo, all those updates 
are build from sources, so every single extra package I have installed 
has a very real cost in terms of repeated update builds over time.  Put a 
bit differently, building and updating from sources tends to rather 
strongly encourage the best security practice of only installing what you 
actually need, because you have to rebuild it at every update.  And I 
don't need pulseaudio enough to be worth the cost to keep it updated, so 
I don't have it installed.  It really is that simple.  Binary-based 
distro users have rather trivial update costs in comparison, so having a 
few extra packages installed that they don't actually use, isn't such a 
big deal for them.  Which is of course fortunate, since dependencies are 
often determined at build-time, and binary-based distros tend to enable 
relatively more of them because /someone/ uses them, even if it's a 
minority, so they tend to carry around more dependencies than the normal 
user will need, simply to support the few that do.  And because the cost 
is relatively lower, users, except for the ones that pay enough attention 
to the security aspect of the wider attack surface, don't generally care 
as much as they would if they were forced to build and update all of them 
from sources!)

So when firefox upstream dropped support for alsa and began requiring 
pulseaudio for users that actually wanted their browser to play sound, I 
had two choices.  I could try to find a workaround that would fake firefox 
into believing that I had pulseaudio, or I could switch back to building 
firefox from sources instead of simply installing the upstream provided 
binaries, since gentoo's firefox build scripts still have the alsa 
support option that upstream firefox refused to support or ship any 
longer.

As with most people and their browsers, firefox is the most security-
exposed app I run, and it sometimes takes gentoo a few days after an 
upstream firefox release to get a working build out, during which users 
waiting on gentoo's package build are exposed to already widely known and 
patched by upstream security issues.  That was more risk than I wanted to 
take, thus my choice of switching to the upstream firefox binaries in the 
first place, since they were available, indeed, autoupdated, on release 
day.  Additionally, a firefox build takes awhile, much longer than most 
other packages, and now requires rust, itself an expensive to build 
package (tho fortunately it doesn't upgrade on the fast cycle that firefox 
does).

So I wasn't particularly happy about being forced back to waiting for 
gentoo to get around to updating its firefox builds several days after 
upstream, and then taking the time to build them myself, making it 
worthwhile to look for a workaround.

And as it happens, there's a /sort/ of workaround called apulse, a much 
simpler and smaller package than pulseaudio itself, that's basically just 
a pulseaudio API wrapper around alsa.

And when I first installed apulse and tested firefox with it, sure 
enough, I got firefox sound back! =:^)  I thought I had my workaround and 
that it was a satisfactory solution.

Unfortunately, apulse appears not to be multi-process-safe, and as firefox 
went more and more multi-process in the announcements, etc, at first I 
couldn't figure out what was keeping firefox single-process for me.

After some research on the web, I found the settings to /force/ firefox-
multi-process, and tried them.  But firefox would then only work in local 
mode (about: pages, basically).  Every time I tried to actually go to a 
normal URL, the multi-process tabs would crash before it rendered a 
thing!  The original firefox UI shell was still running, but with an 
error message indicating the tab crash instead of the page I wanted.

After some troubleshooting I figured out it was apulse.  If I moved the 
apulse library out of the way so firefox couldn't find it, I could browse 
the web in multiprocess mode just fine... except I was of course missing 
audio again. =:^(

So apulse wasn't the workaround for upstream firefox now requiring 
pulseaudio that I thought it was, since apulse wouldn't work with multi-
process, and I had to switch back to gentoo's firefox build from sources 
in ordered to get the alsa support that upstream had dropped, after all.


Thus, it wasn't pulseaudio that was the problem with multiprocess, but 
the fact that firefox had dropped alsa and was forcing pulseaudio on 
Linux if you wanted audio at all, and the fact that the apulse workaround 
I thought I had, didn't work with multiprocess.  So it was apulse that 
was the problem, and pulseaudio was only involved because firefox 
dropping direct alsa support and forcing pulseaudio was what had me 
installing apulse as an attempted workaround.


Meanwhile, my intent with the original mention wasn't that apulse was 
likely your problem, that's relatively unlikely, but that you might have 
some /other/ problem, say a not electrolysis-enabled (aka e10s, e, ten-
letters, s) extension.

Back when I posted that, a not e10s-enabled extension was actually quite 
likely, as e10s was still rather new.  It's probably somewhat less so 
now, and firefox is of course on to the next big change, dropping the old 
"legacy chrome" extension support, in favor of the newer and generally 
Chromium-compatible WebExtensions/WE API, with firefox 57, to be released 
mid-month (Nov 14).

But assuming you're still seeing firefox performance issues, I'm still 
guessing that it's likely to be /something/ forcing single-process, as I 
/know/ how much of a difference that can make from experience.

So I'd definitely check it, and if you're not getting multi-process, the 
firefox about:support page should show it in the application basics 
section, multiprocess windows, and if that's working, web content 
processes, entries.  With luck it'll tell you why it's disabled if it is, 
saying something about incompatible extensions or the like, tho I had to 
do a bit more troubleshooting to find the problem with apulse.

If with multiple firefox windows open you're seeing 2/2 (or higher) in 
the multiprocess windows entry, and n/4 (the default, here I forced a 
higher 7) in the web content processes entry, then you're good to go in 
this regard, and the problem must be elsewhere.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

