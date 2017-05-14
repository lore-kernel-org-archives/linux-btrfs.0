Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35122 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdENIrL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 04:47:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9pB9-0003sG-Jd
        for linux-btrfs@vger.kernel.org; Sun, 14 May 2017 10:47:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs/SSD
Date: Sun, 14 May 2017 08:46:57 +0000 (UTC)
Message-ID: <pan$794a6$bb4e6c5e$1ea79397$97df92ee@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Fri, 12 May 2017 15:02:20 +0200 as excerpted:

> On 5/12/17, Duncan <1i5t5.duncan@cox.net> wrote:
>> FWIW, I'm in the market for SSDs ATM, and remembered this from a couple
>> weeks ago so went back to find it.  Thanks. =:^)
>>
>> (I'm currently still on quarter-TB generation ssds, plus spinning rust
>> for the larger media partition and backups, and want to be rid of the
>> spinning rust, so am looking at half-TB to TB, which seems to be the
>> pricing sweet spot these days anyway.)
> 
> Since you are taking ssds to mainstream based on your experience,
> I guess your perception of data retension/reliability is better than
> that of spinning rust. Right? Can you eloborate?
> 
> Or an other criteria might be physical constraints of spinning rust on
> notebooks which dictates that you should handle the device with care
> when running.
> 
> What was your primary motivation other than performance?

Well, the /immediate/ motivation is that the spinning rust is starting to 
hint that it's time to start thinking about rotating it out of service...

It's my main workstation so wall powered, but because it's the media and 
secondary backups partitions, I don't have anything from it mounted most 
of the time and because it /is/ spinning rust, I allow it to spin down.  
It spins right back up if I mount it, and reads seem to be fine, but if I 
let it set a bit after mount, possibly due to it spinning down again, 
sometimes I get write errors, SATA resets, etc.  Sometimes the write will 
then eventually appear to go thru, sometimes not, but once this happens, 
unmounting often times out, and upon a remount (which may or may not work 
until a clean reboot), the last writes may or may not still be there.

And the smart info, while not bad, does indicate it's starting to age, 
tho not extremely so.

Now even a year ago I'd have likely played with it, adjusting timeouts, 
spindowns, etc, attempting to get it working normally again.

But they say that ssd performance spoils you and you don't want to go 
back, and while it's a media drive and performance isn't normally an 
issue, those secondary backups to it as spinning rust sure take a lot 
longer than the primary backups to other partitions on the same pair of 
ssds that the working copies (of everything but media) are on.

Which means I don't like to do them... which means sometimes I put them 
off longer than I should.  Basically, it's another application of my 
"don't make it so big it takes so long to maintain you don't do it as you 
should" rule, only here, it's not the size but rather because I've been 
spoiled by the performance of the ssds.


So couple the aging spinning rust with the fact that I've really wanted 
to put media and the backups on ssd all along, only it couldn't be cost-
justified a few years ago when I bought the original ssds, and I now have 
my excuse to get the now cheaper ssds I really wanted all along. =:^)


As for reliability...  For archival usage I still think spinning rust is 
more reliable, and certainly more cost effective.

However, for me at least, with some real-world ssd experience under my 
belt now, including an early slow failure (more and more blocks going 
bad, I deliberately kept running it in btrfs raid1 mode with scrubs 
handling the bad blocks for quite some time, just to get the experience 
both with ssds and with btrfs) and replacement of one of the ssds with 
one I had originally bought for a different machine (my netbook, which 
went missing shortly thereafter), I now find ssds reliable enough for 
normal usage, certainly so if the data is valuable enough to have backups 
of it anyway, and if it's not valuable enough to be worth doing backups, 
then losing it is obviously not a big deal, because it's self-evidently 
worth less than the time, trouble and resources of doing that backup.

Particularly so if the speed of ssds helpfully encourages you to keep the 
backups more current than you would otherwise. =:^)

But spinning rust remains appropriate for long-term archival usage, like 
that third-level last-resort backup I like to make, then keep on the 
shelf, or store with a friend, or in a safe deposit box, or whatever, and 
basically never use, but like to have just in case.  IOW, that almost 
certainly write once, read-never, seldom update, last resort backup.  If 
three years down the line there's a fire/flood/whatever, and all I can 
find in the ashes/mud or retrieve from that friend is that three year old 
backup, I'll be glad to still have it.

Of course those who have multi-TB scale data needs may still find 
spinning rust useful as well, because while 4-TB ssds are available now, 
they're /horribly/ expensive.  But with 3D-NAND, even that use-case looks 
like it may go ssd in the next five years or so, leaving multi-year to 
decade-plus archiving, and perhaps say 50-TB-plus, but that's going to 
take long enough to actually write or otherwise do anything with it's 
effectively archiving as well, as about the only remaining spinning rust 
holdout.

Meanwhile, it'll be interesting to see if once ssds are used for 
everything else and there's no other legacy hdd territory to expand into, 
if they come up with a reasonable archiving solution for them as well.
Considering that picking up that old pre-2010 thumb-drive (or MP3 player 
you found in the back of the drawer) and a burnt CD/DVDROM from the same 
period, the flash-based thumb drive or mp3 player is far more likely to 
continue to safely hold its data, one might reasonably believe archival 
flash style ssds are well within reason.  Basically, we already have 
them, we just have to adjust the physical format a bit, and build and 
market them to that purpose, plus scale down the cost, of course, but 
that could easily come if it were addressed to the same scale that 
they've been addressing the ssds as main storage problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

