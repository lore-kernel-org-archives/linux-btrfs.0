Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37836 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbK3FCy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 00:02:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a3Gbv-0006WI-6R
	for linux-btrfs@vger.kernel.org; Mon, 30 Nov 2015 06:02:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 06:02:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 06:02:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
Date: Mon, 30 Nov 2015 05:02:43 +0000 (UTC)
Message-ID: <pan$dfd56$d94661c9$2e95ffe8$7f001483@cox.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
	<CAPmG0jbso5RM4UW_urBKa02LOKreCTx2PjX7YyUp6nuqOONo=Q@mail.gmail.com>
	<pan$8c5a3$43576c38$c4ab8cd7$5fc9a224@cox.net>
	<CAPmG0jZkK-2iJ0vd3L08Fkap-XdrSx_jSn5ZgZzOk1wvbAzEqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sun, 29 Nov 2015 20:29:49 +0100 as excerpted:

> On Sun, Nov 29, 2015 at 6:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> What are you using to tell you it has 1018391 extents?  If you're using
>> filefrag, it's known not to understand btrfs compression, which uses
>> 128 KiB (pre-compression size, I believe, tho I'm not absolutely
>> positive) blocks, and as a result, to report each of those blocks as a
>> separate extent.

> Indeed filefrag, and filefrag -k -v results in a 72M txt file, almost
> all 'extents' show length:128, but also several a bit bigger or much
> bigger.

Hmm... I wonder... Were they multiples of 128?  I'm not a coder but with 
your results it occurs to me that for sections that compress 
"negatively", that is, that end up larger when "compressed" than when 
not, perhaps even compress-force doesn't compress in that case, which, 
presuming there's several in a row, would then appear as a single extent 
to filefrag (assuming it actually is and the only reason filefrag would 
split it up in reports would be due to the compression), as it would then 
know how to map them properly.

Regardless, that's entirely new information to me, as I figured with 
compressed files it saw each 128 KiB as a separate extent, regardless.

Meanwhile, I didn't know about the -v actually showing the addresses so 
real extents could be manually calculated, either.  The manpage simply 
says "be verbose", which isn't particularly helpful, and I'd obviously 
never tried it.

> From just quickly browsing and random checks, it seems mostly contiguous
> (on linux block layer level or from what filefrag sees), it looks like
> it is not so difficult to change filefrag so that it also reports the
> amount of discontinuities. But maybe there is other 'misunderstanding'
> between filefrag and btrfs, so then we would need something dedicated.
> filefrag execution takes long time mostly (minutes), even just for 1
> though big file.

So filefrag -v's practical verbosity is new and quite useful information 
as well. =:^)  In fact, given that new info and enough motivation, I 
could almost certainly hack up a script to do the address comparisons and 
report actual extents here, tho obviously it'd be far less efficient than 
actually writing the same in native code, the result if filefrag itself 
were to "learn" about btrfs compression.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

