Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33918 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaLHOr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:47:29 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Mon, 08 Dec 2014 15:47:23 +0100
Message-ID: <1447188.5moEuATfqD@merkaba>
In-Reply-To: <548537D1.7070602@pobox.com>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <1610909.CxuY1Bb9iL@merkaba> <548537D1.7070602@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Am Sonntag, 7. Dezember 2014, 21:32:01 schrieb Robert White:
> On 12/07/2014 07:40 AM, Martin Steigerwald wrote:
> > Well what would be possible I bet would be a kind of system call like
> > this:
> > 
> > I need to write 5 GB of data in 100 of files to /opt/mynewshinysoftware,
> > can I do it *and* give me a guarentee I can.
> > 
> > So like a more flexible fallocate approach as fallocate just allocates one
> > file and you would need to run it for all files you intend to create. But
> > challenge would be to estimate metadata allocation beforehand accurately.
> > 
> > Or have tar --fallocate -xf which for all files in the archive will first
> > call fallocate and only if that succeeded, actually write them. But due
> > to the nature of tar archives with their content listing across the whole
> > archive, this means it may have to read the tar archive twice, so ZIP
> > archives might be better suited for that.
> 
> What you suggest is Still Not Practical™ (the tar thing might have some
> ability if you were willing to analyze every file to the byte level).
> 
> Compression _can_ make a file _bigger_ than its base size. BTRFS decides
> whether or not to compress a file based on the results it gets when
> tying to compress the first N bytes. (I do not know the value of N). But
> it is _easy_ to have a file where the first N bytes compress well but
> the bytes after N take up more space than their byte count. So to
> fallocate() the right size in blocks you'd have to compress the input
> and determine what BTRFS _would_ _do_ and then allocate that much space
> instead of the file size.
> 
> And even then, if you didn't create all the names and directories you
> might find that the RBtree had to expand (allocate another tree node)
> one or more times to accommodate the actual files. Lather rinse repeat
> for any checksum trees and anything hitting a flush barrier because of
> commit= or sync() events or other writers perturbing your results
> because it only matters if the filesystem is nearly full and nearly full
> filesystems may not be quiescent at all.
> 
> So while the core problem isn't insoluble, in real life it is _not_
> _worth_ _solving_.
> 
> On a nearly empty filesystem, it's going to fit.
> 
> In a reasonably empty filesystem, it's going to fit.
> 
> On a nearly full filesystem, it may or may not fit.
> 
> On a filesystem that is so close to full that you have reason to doubt
> it will fit, you are going to have a very bad time even if it fits.
> 
> If you did manage to invent and implement an fallocate algorythm that
> could make this promise and make it stick, then some other running
> program is what's going to crash when you use up that last byte anyway.
> 
> Almost full filesystems are their own reward.

So you basically say that BTRFS with compression  does not meet the fallocate 
guarantee. Now thats interesting, cause it basically violates the 
documentation for the system call:

DESCRIPTION
       The function posix_fallocate() ensures that disk space  is  allo‐
       cated for the file referred to by the descriptor fd for the bytes
       in the range starting at offset and  continuing  for  len  bytes.
       After  a  successful call to posix_fallocate(), subsequent writes
       to bytes in the  specified  range  are  guaranteed  not  to  fail
       because of lack of disk space.

So in order to be standard compliant there, BTRFS would need to write 
fallocated files uncompressed… wow this is getting complex.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
