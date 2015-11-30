Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33450 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbK3S0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 13:26:24 -0500
Received: by lfaz4 with SMTP id z4so208944908lfa.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 10:26:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$dfd56$d94661c9$2e95ffe8$7f001483@cox.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
	<CAPmG0jbso5RM4UW_urBKa02LOKreCTx2PjX7YyUp6nuqOONo=Q@mail.gmail.com>
	<pan$8c5a3$43576c38$c4ab8cd7$5fc9a224@cox.net>
	<CAPmG0jZkK-2iJ0vd3L08Fkap-XdrSx_jSn5ZgZzOk1wvbAzEqA@mail.gmail.com>
	<pan$dfd56$d94661c9$2e95ffe8$7f001483@cox.net>
Date: Mon, 30 Nov 2015 19:26:22 +0100
Message-ID: <CAPmG0jaBxu1-TKR8JeJZLO-R9sXvv=A5uu9a9njLTqGK6y81YA@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Henk Slager <eye1tm@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 6:02 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> What are you using to tell you it has 1018391 extents?  If you're using
>>> filefrag, it's known not to understand btrfs compression, which uses
>>> 128 KiB (pre-compression size, I believe, tho I'm not absolutely
>>> positive) blocks, and as a result, to report each of those blocks as a
>>> separate extent.
>
>> Indeed filefrag, and filefrag -k -v results in a 72M txt file, almost
>> all 'extents' show length:128, but also several a bit bigger or much
>> bigger.
>
> Hmm... I wonder... Were they multiples of 128?  I'm not a coder but with
> your results it occurs to me that for sections that compress
> "negatively", that is, that end up larger when "compressed" than when
> not, perhaps even compress-force doesn't compress in that case, which,
> presuming there's several in a row, would then appear as a single extent
> to filefrag (assuming it actually is and the only reason filefrag would
> split it up in reports would be due to the compression), as it would then
> know how to map them properly.
They are all multiples of 128, and 128 is the smallest.
I also had these kind of questions about btrfs compression. I just
took the risk that maybe audio/video and .tar.gz files etc might eat
slightly more space when copied to an fs with compress-force=zlib. I
know also that a significant part of my files compress well (factor
~2),  so overall for multi-Terabytes archiving, I am OK with the
situation.

The extent and chunk handling in general (so without crypto and
compression) is what me triggered via this mail-threat. Same as Chris
A.M., I see some storage throughput drops where I don't actually
expect them. It's on fast SSD, where similar files (VM images) achieve
~540MiB/s read throughput and 1 file just large parts only ~45MiB/s. A
partial balance did not help, a cp --reflink=never did. All VMs have
in order of 100k filefrag reported extents. It's not a noticeable
problem for VM running speed and I still have older snapshots around
of the VM that shows the read-slowness. Maybe something not reported
in dmesg is wrong, I will not do full balance or reboot or fs check do
right now, latest early next year. My best guesses are that the
extents are very much scattered in many blockgroups or some issue
inside the SSD that smartctl does not show.

> Regardless, that's entirely new information to me, as I figured with
> compressed files it saw each 128 KiB as a separate extent, regardless.
>
> Meanwhile, I didn't know about the -v actually showing the addresses so
> real extents could be manually calculated, either.  The manpage simply
> says "be verbose", which isn't particularly helpful, and I'd obviously
> never tried it.
>
>> From just quickly browsing and random checks, it seems mostly contiguous
>> (on linux block layer level or from what filefrag sees), it looks like
>> it is not so difficult to change filefrag so that it also reports the
>> amount of discontinuities. But maybe there is other 'misunderstanding'
>> between filefrag and btrfs, so then we would need something dedicated.
>> filefrag execution takes long time mostly (minutes), even just for 1
>> though big file.
>
> So filefrag -v's practical verbosity is new and quite useful information
> as well. =:^)  In fact, given that new info and enough motivation, I
> could almost certainly hack up a script to do the address comparisons and
> report actual extents here, tho obviously it'd be far less efficient than
> actually writing the same in native code, the result if filefrag itself
> were to "learn" about btrfs compression.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
