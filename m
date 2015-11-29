Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34634 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbbK2T3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 14:29:50 -0500
Received: by lffu14 with SMTP id u14so174101336lff.1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Nov 2015 11:29:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$8c5a3$43576c38$c4ab8cd7$5fc9a224@cox.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
	<CAPmG0jbso5RM4UW_urBKa02LOKreCTx2PjX7YyUp6nuqOONo=Q@mail.gmail.com>
	<pan$8c5a3$43576c38$c4ab8cd7$5fc9a224@cox.net>
Date: Sun, 29 Nov 2015 20:29:49 +0100
Message-ID: <CAPmG0jZkK-2iJ0vd3L08Fkap-XdrSx_jSn5ZgZzOk1wvbAzEqA@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Henk Slager <eye1tm@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 29, 2015 at 6:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> What are you using to tell you it has 1018391 extents?  If you're using
> filefrag, it's known not to understand btrfs compression, which uses 128
> KiB (pre-compression size, I believe, tho I'm not absolutely positive)
> blocks, and as a result, to report each of those blocks as a separate
> extent.
Indeed filefrag, and filefrag -k -v results in a 72M txt file, almost
all 'extents' show length:128, but also several a bit bigger or much
bigger.
>From just quickly browsing and random checks, it seems mostly
contiguous (on linux block layer level or from what filefrag sees), it
looks like it is not so difficult to change filefrag so that it also
reports the amount of discontinuities. But maybe there is other
'misunderstanding' between filefrag and btrfs, so then we would need
something dedicated. filefrag execution takes long time mostly
(minutes), even just for 1 though big file.

> Because if you're using compress-force, filefrag will see each 128 KiB
> compression block as an extent, and 1018391 reported "extents" (actually
> compression blocks) should be ~ 125 GiB.
See also above;
file is 176521162380 bytes ~= 164.4 GiB and ls -lh reports 165G

> AFAIK there's no easy "admin-level" way to check extent usage when btrfs
> compression is used on a file.  There's developer-level btrfs-debug
> output, but nothing admin-level or user-level at all.
I would be interested in tooling that gives more visibility on what
happens on btrfs disk-block level, primarily just for non-compression
use-cases. If you know some, please let us know.

> And while compress-force won't change the reported "extents" that are
> actually compression-blocks if the file is actually compressed, just
> compress by itself may or may not actually compress the file (there's an
> algorithm used, from what the devs have said, basically it checks whether
> the first block or two compress well, and assumes the rest of the file
> will be similar, compressing or not based on the result of that attempt),
This method is probably a good method for live data being written, but
for static content (my data files), it turned out to be not good
enough, i.e. total space gained in TeraByte range was not what I
expected/wanted.

> so it's quite possible you'll get better "extent" numbers if the file
> isn't actually compressed, in which case filefrag actually gets things
> right and reports real extent numbers, vs the number of compression
> blocks if the file is compressed.
I think you mean that when the destination block of the file are not
re-compressed (and stored on disk) but left and stored as the
unprocessed source datablock. Indeed, when I first e.g gzip the file,
it's then 75G and filefrag reports 8613 extents, most of them 512KiB
