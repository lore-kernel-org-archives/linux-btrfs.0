Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:42904 "EHLO mail.crc.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751602AbcILBAu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 21:00:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 12 Sep 2016 11:00:45 +1000
From: Steven Haigh <netwiz@crc.id.au>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compress=lzo safe to use?
In-Reply-To: <4096253.hu8ZAHGEqT@merkaba>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
 <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
 <4096253.hu8ZAHGEqT@merkaba>
Message-ID: <bcd02f62aa49ca4f17bb94e0253f048a@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 05:48, Martin Steigerwald wrote:
> Am Sonntag, 26. Juni 2016, 13:13:04 CEST schrieb Steven Haigh:
>> On 26/06/16 12:30, Duncan wrote:
>> > Steven Haigh posted on Sun, 26 Jun 2016 02:39:23 +1000 as excerpted:
>> >> In every case, it was a flurry of csum error messages, then instant
>> >> death.
>> >
>> > This is very possibly a known bug in btrfs, that occurs even in raid1
>> > where a later scrub repairs all csum errors.  While in theory btrfs raid1
>> > should simply pull from the mirrored copy if its first try fails checksum
>> > (assuming the second one passes, of course), and it seems to do this just
>> > fine if there's only an occasional csum error, if it gets too many at
>> > once, it *does* unfortunately crash, despite the second copy being
>> > available and being just fine as later demonstrated by the scrub fixing
>> > the bad copy from the good one.
>> >
>> > I'm used to dealing with that here any time I have a bad shutdown (and
>> > I'm running live-git kde, which currently has a bug that triggers a
>> > system crash if I let it idle and shut off the monitors, so I've been
>> > getting crash shutdowns and having to deal with this unfortunately often,
>> > recently).  Fortunately I keep my root, with all system executables, etc,
>> > mounted read-only by default, so it's not affected and I can /almost/
>> > boot normally after such a crash.  The problem is /var/log and /home
>> > (which has some parts of /var that need to be writable symlinked into /
>> > home/var, so / can stay read-only).  Something in the normal after-crash
>> > boot triggers enough csum errors there that I often crash again.
>> >
>> > So I have to boot to emergency mode and manually mount the filesystems in
>> > question, so nothing's trying to access them until I run the scrub and
>> > fix the csum errors.  Scrub itself doesn't trigger the crash, thankfully,
>> > and once it has repaired all the csum errors due to partial writes on one
>> > mirror that either were never made or were properly completed on the
>> > other mirror, I can exit emergency mode and complete the normal boot (to
>> > the multi-user default target).  As there's no more csum errors then
>> > because scrub fixed them all, the boot doesn't crash due to too many such
>> > errors, and I'm back in business.
>> >
>> >
>> > Tho I believe at least the csum bug that affects me may only trigger if
>> > compression is (or perhaps has been in the past) enabled.  Since I run
>> > compress=lzo everywhere, that would certainly affect me.  It would also
>> > explain why the bug has remained around for quite some time as well,
>> > since presumably the devs don't run with compression on enough for this
>> > to have become a personal itch they needed to scratch, thus its remaining
>> > untraced and unfixed.
>> >
>> > So if you weren't using the compress option, your bug is probably
>> > different, but either way, the whole thing about too many csum errors at
>> > once triggering a system crash sure does sound familiar, here.
>> 
>> Yes, I was running the compress=lzo option as well... Maybe here lays 
>> a
>> common problem?
> 
> Hmm… I found this from being referred to by reading Debian wiki page on
> BTRFS¹.
> 
> I use compress=lzo on BTRFS RAID 1 since April 2014 and I never found 
> an
> issue. Steven, your filesystem wasn´t RAID 1 but RAID 5 or 6?

Yes, I was using RAID6 - and it has had a track record of eating data. 
There's lots of problems with the implementation / correctness of 
RAID5/6 parity - which I'm pretty sure haven't been nailed down yet. The 
recommendation at the moment is just not to use RAID5 or RAID6 modes of 
BTRFS. The last I heard, if you were using RAID5/6 in BTRFS, the 
recommended action was to migrate your data to a different profile or a 
different FS.

> I just want to assess whether using compress=lzo might be dangerous to 
> use in
> my setup. Actually right now I like to keep using it, since I think at 
> least
> one of the SSDs does not compress. And… well… /home and / where I use 
> it are
> both quite full already.

I don't believe the compress=lzo option by itself was a problem - but it 
*may* have an impact in the RAID5/6 parity problems? I'd be guessing 
here, but am happy to be corrected.

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
