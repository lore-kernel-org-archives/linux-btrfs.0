Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35811 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcBGAkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Feb 2016 19:40:41 -0500
Received: by mail-lf0-f49.google.com with SMTP id l143so77426273lfe.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 16:40:40 -0800 (PST)
Subject: Re: Unrecoverable error on raid10
To: Chris Murphy <lists@colorremedies.com>
References: <56B66704.5070505@gmail.com>
 <CAJCQCtSOv8rhDi69NyR6J4cs91bc9ahh7382+kHz1knAe5BRdg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Tom Arild Naess <tanaess@gmail.com>
Message-ID: <56B69286.3080205@gmail.com>
Date: Sun, 7 Feb 2016 01:40:38 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSOv8rhDi69NyR6J4cs91bc9ahh7382+kHz1knAe5BRdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07. feb. 2016 00:32, Chris Murphy wrote:

> It's probably unrelated the problem, but I would given the many bug
> fixes (including in send/receive) since kernel 3.19, and progs 4.1,
> that I'd get both systems using the same kernel and progs version. I
> suspect most of upstream's testing before release for send/receive is
> with matching kernel and progs versions. My understanding is most of
> the send code is in the kernel, and most of the receive code is in
> progs (of course, receive also implies writing to a Btrfs volume as
> well which would be kernel code too). I really wouldn't intentionally
> mix and match versions like this, unless you're trying to find bugs as
> a result of mismatching versions.
Ok, that sounds like good advice. My thought was to keep the versions 
different to reduce the risk of my data getting nuked on both systems 
because of some obscure bug in one specific version, since btrfs is not 
100% stable yet. Also, it was much easier to create a small read-only 
"NAS OS" to run from a USB stick using Arch Linux than with Ubuntu. 
Guess I'll have to re-evaluate this then.

> Note that this is a logical address. The chunk tree will translate
> that into separate physical sectors on the actual drives. This kind of
> corruption suggests that it's not media, or even storage stack related
> like a torn write or anything like that. I'm not sure how it can
> happen, someone else who knows the sequence of data checksumming, data
> allocation being split into two paths for writes, and metadata writes,
> would have to speak up.
Being a logical or physical address is not the point here at all. The 
file ended up corrupted because somehow both copies of the file had a 
checksum mismatch on the exact same (4k) block of data. This should not 
be possible. For now I can only see two explanations - a weird bug 
somewhere in btrfs or corrupt RAM, because either the data block or the 
checksum must have been corrupted somewhere between the calculation and 
writing to the disk. Next step now is a few rounds of memtest.
> Also, the file is still recoverable most likely. You can use btrfs
> restore to extract it from the unmounted file system without
> complaining about checksum mismatches. It's just that the normal read
> path won't hand over data it thinks is corrupt.
I still haven't learned enough about the capabilities of btrfs, so I 
wasn't aware of this. And since this was the backup server, I replaced 
the file from the main server to see if this would break the incremental 
send/receive (and that worked perfectly, since I kept the inode i guess).

>> This is not what I expect from a raid10!
> Technically what you don't expect from raid10 is any notification that
> the file may be corrupt at all. It'd be interesting to extract the
> file with restore, and then compare hashes to a known good copy.
Well, I really don't expect this to be happening at all. If this is a 
bug in btrfs, it could just as well have struck the same file on the 
server. Without a backup I could not know if it was the data or the 
checksum that was bogus. This being a 16GB edited family film video 
file, I had the original source deleted, so I could very well end up 
with some very annoying chop in the video in a worst case scenario.

Anyway, I just hope that if there is a bug in the code, this could help 
find it.

-- 
Tom Arild Naess

