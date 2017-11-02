Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:43058 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932433AbdKBAKD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 20:10:03 -0400
Received: by mail-wm0-f44.google.com with SMTP id m72so463292wmc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 17:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23034.2305.527872.772343@tree.ty.sabi.co.uk>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net> <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk> <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <23034.2305.527872.772343@tree.ty.sabi.co.uk>
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 20:09:41 -0400
Message-ID: <CAH=dxU6bhi=xwugt+nynU5BSnvBzZ5L=C5nxPt39v14YwhcNCA@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btfs.list.sabi.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 1:48 PM, Peter Grandi <pg@btfs.list.sabi.co.uk> wrote:
>> When defragmenting individual files on a BTRFS filesystem with
>> COW, I assume reflinks between that file and all snapshots are
>> broken. So if there are 30 snapshots on that volume, that one
>> file will suddenly take up 30 times more space... [ ... ]
>
> Defragmentation works by effectively making a copy of the file
> contents (simplistic view), so the end result is one copy with
> 29 reflinked contents, and one copy with defragmented contents.

The clarification is much appreciated.

>> Can you also give an example of using find, as you suggested
>> above? [ ... ]
>
> Well, one way is to use 'find' as a filtering replacement for
> 'defrag' option '-r', as in for example:
>
>   find "$HOME" -xdev '(' -name '*.sqlite' -o -name '*.mk4' ')' \
>     -type f  -print0 | xargs -0 btrfs fi defrag
>
> Another one is to find the most fragmented files first or all
> files of at least 1M with with at least say 100 fragments as in:
>
>   find "$HOME" -xdev -type f -size +1M -print0 | xargs -0 filefrag \
>     | perl -n -e 'print "$1\0" if (m/(.*): ([0-9]+) extents/ && $1 > 100)' \
>     | xargs -0 btrfs fi defrag
>
> But there are many 'find' web pages and that is not quite a
> Btrfs related topic.

Your examples were perfect. I have experience using find in similar
ways. I can take it from there. :-)

>> Background: I'm not sure why our Firefox performance is so terrible
>
> As I always say, "performance" is not the same as "speed", and
> probably your Firefox "performance" is sort of OKish even if the
> "speed" is terrile, and neither is likely related to the profile
> or the cache being on Btrfs.

Here's what happened. Two years ago I installed Kubuntu (with Firefox)
on two desktop computers. One machine performed fine. Like you said,
"sort of OKish" and that's what we expect with the current state of
Linux. The other machine was substantially worse. We ran side-by-side
real-world tests on these two machines for months.

Initially I did a lot of testing, troubleshooting and reconfiguration
trying to get the second machine to perform as well as the first. I
never had success. At first I thought it was related to the GPU (or
driver). Then I thought it was because the first machine used the z170
chipset and the second was X99 based. But that wasn't it. I have never
solved the problem and I have been coming back to it periodically
these last two years. In that time I have tried different distros from
opensuse to Arch, and a lot of different hardware.

Furthermore, my new machines have the same performance problem. The
most interesting example is a high end machine with 256 GB of RAM. It
showed substantially worse desktop application performance than any
other computer here. All are running the exact same version of Firefox
with the exact same add-ons. (The installations are carbon copies of
each other.)

What originally caught my attention was earlier information in this thread:

Am Wed, 20 Sep 2017 07:46:52 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> >      Fragmentation: Files with a lot of random writes can become
> > heavily fragmented (10000+ extents) causing excessive multi-second
> > spikes of CPU load on systems with an SSD or large amount a RAM. On
> > desktops this primarily affects application databases (including
> > Firefox). Workarounds include manually defragmenting your home
> > directory using btrfs fi defragment. Auto-defragment (mount option
> > autodefrag) should solve this problem.
> >
> > Upon reading that I am wondering if fragmentation in the Firefox
> > profile is part of my issue. That's one thing I never tested
> > previously. (BTW, this system has 256 GB of RAM and 20 cores.)
> Almost certainly.  Most modern web browsers are brain-dead and insist
> on using SQLite databases (or traditional DB files) for everything,
> including the cache, and the usage for the cache in particular kills
> performance when fragmentation is an issue.

It turns out the the first machine (which performed well enough) was
the last one which was installed using LVM + EXT4. The second machine
(the one with the original performance problem) and all subsequent
machines have used BTRFS.

And the worst performing machine was the one with the most RAM and a
fast NVMe drive and top of the line hardware.

While Firefox and Linux in general have their performance "issues",
that's not relevant here. I'm comparing the same distros, same Firefox
versions, same Firefox add-ons, etc. I eventually tested many hardware
configurations: different CPU's, motherboards, GPU's, SSD's, RAM, etc.
The only remaining difference I can find is that the computer with
acceptable performance uses LVM + EXT4 while all the others use BTRFS.

With all the great feedback I have gotten here, I'm now ready to
retest this after implementing all the BTRFS-related suggestions I
have received. Maybe that will solve the problem or maybe this mystery
will continue...
