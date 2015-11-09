Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbbKIBvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 20:51:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZvbcF-0004sW-Kj
	for linux-btrfs@vger.kernel.org; Mon, 09 Nov 2015 02:51:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 02:51:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 02:51:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange "No space left on device"
Date: Mon, 9 Nov 2015 01:51:19 +0000 (UTC)
Message-ID: <pan$cae0f$34bd8945$48460662$225575f1@cox.net>
References: <1446938562.7297.7.camel@scientia.net>
	<CAPmG0jb_ynq6qnxf-bysNaLut+5SOGqHrizLMaMN-1o6r2SZwg@mail.gmail.com>
	<pan$1751c$67da8858$62f444f5$4f9a54fc@cox.net>
	<1447020657.1068.6.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 08 Nov 2015 23:10:57 +0100 as
excerpted:

> On Sun, 2015-11-08 at 20:39 +0000, Duncan wrote:
>> Wow, yes!  Good catch, Henk! =:^)  Hugo obviously didn't catch it,
>> and I wouldn't have either, as the bad size detection behavior is so
>> unexpected, it just wouldn't occur to me to look!
> Hmm... all that *may* be more likely an error of myself when copying and
> pasting the terminal output together:
> 
> I did actually change the 3rd partition to use 1GiB in later tries at
> the expense of the 5th one shrinking, so the part table would have
> looked like this in these later tries:
> 512M 1G 1G 1G 4G

Oops! =:^(

> Which would again fit the output of the various mkfs.btrfs.
> 
> Sorry if that was the case, apologies for any confusion.
> 
> 
> The problem seemed to went away when explicitly using --mixed.

Good.  Whatever the cause of it not doing mixed by default (perhaps it's 
an off-by-one error and filesystems of exactly 1 GiB weren't defaulting 
to mixed as expected), the fact that mixed was the default on small 
filesystems would mean separate data/metadata wouldn't have gotten the 
same full testing coverage, so maybe there's a bug...  In which case the 
4.3 change discussed below would certainly tend to trigger it more often, 
hopefully getting it fixed. =:^)


>> (Apparently, btrfs-progs-4.3 does away with the default to mixed- mode
>> at 1 GiB or under, tho it is still recommended.

> Well I still had 4.2 ...

That's why I had that as a parenthetical.  It didn't apply to your 
current case, but could to others, and I've learned to write with both 
the lurkers and the googlers who will happen on my post later, in mind.

>> I'm not exactly sure of why, tho I think it had to do with being able
>> to use sub-GiB btrfs for testing without having to worry about mixed
>> mode.

> Kinda strange... shouldn't it work out of the box for users and not
> developers?

> To be honest, no one should need to read through the wiki, just to be
> able to create a small sized fs.

That's why, tho I didn't press it, I asked for clarification when I saw 
it mentioned on the btrfs-progs 4.3-rc1 announcement, verifying that 
mixed was still recommended.  Chris Murphy (another non-btrfs-dev list 
regular, I think he works or volunteers for one of the distros) 
questioned it as well, on the same announcement.

But not being able to personally show-them-the-code, as long as there's 
at least an option to do it the way I want (which there is, the already 
mentioned --mixed option), I've learned not to press it.[1]

> And even if no mixed D/M block group allocation was used... it shouldn't
> just fail out-of-the-box with a few byte large files on a 1 GB fs.

You are absolutely correct.  There's a bug somewhere.  Earlier I thought 
it was the size detection bug Henk spotted, since even if there's some 
other bug here it'd pale in comparision, but since that bug turned out to 
trace to your copy/paste, that isn't it, and we still have the much more 
ordinary level bug to deal with.

But as I said above, with progs 4.3 defaulting to unmixed even on small 
filesystems now, if indeed it is tied to unmixed on a small filesystem, 
that bug's very likely to get MUCH more common, and thus should be fixed 
relatively quickly, I'd guess by the time 4.4 comes out, given the 
history of other bugs that turn out to be quite common.

---
[1] Tho for my own systems I sometimes patch in the behavior as I think 
it should be, as my patching of existing code skills are dramatically 
better than my new-coding skills, and I run gentoo so already build 
everything from sources.  I finally got tired of the kernel not 
defaulting to noatime, and hacked up a patch to do it, so I could remove 
noatime from all my fstab entries, for instance.  But I already use a 
mkfs.btrfs helper script that adds options I prefer, so in this 
particular case, simply adding --mixed under appropriate conditions in 
the script is a far easier personal solution.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

