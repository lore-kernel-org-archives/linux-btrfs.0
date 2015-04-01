Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35042 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbDABdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 21:33:15 -0400
Received: by igcau2 with SMTP id au2so35386035igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 18:33:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
Date: Tue, 31 Mar 2015 19:33:14 -0600
Message-ID: <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 5:54 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> On Tue, Mar 31, 2015 at 4:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> There should be a reference to an rdsosreport.txt in /run/... so find
>> a way to get that posted somewhere.
>
> I'll try, but it truly says nothing of interest from a block device /
> btrfs PoV. I have ample background debugging boot issues, disk
> corruption, etc from years of work w OLPC.

If there is no reference in this dracut shell to rdsosreport.txt, then use:
journalctl -b -l -o short-monotonic

You can mount anything at /sysroot including the boot partition if you
want, or a USB stick. The usual directories aren't available in the
initramfs before switchroot happens.


> That's a good idea! I was referring to something else -- I guess what
> I'm trying to say is: I'm not sure if this scrambled disk partition is
> a btrfs/kernel bug, or the cheap HDD lied about flushing a write to
> disk.

This is the realm of both esoteric knowledge and an active area of
research how to get reliable information about "what happened when the
power cut out." So you're not the only one not sure.


-- 
Chris Murphy
