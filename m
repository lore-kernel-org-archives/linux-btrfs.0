Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49322 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaCYBLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 21:11:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSFuC-00059B-Kl
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 02:11:52 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 02:11:52 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 02:11:52 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Btrfs and raid5 status with kernel 3.14, documentation, and howto
Date: Tue, 25 Mar 2014 01:11:43 +0000
Message-ID: <lgql40$lm5$1@ger.gmane.org>
References: <20140323225657.GA17039@merlins.org> <lgq0b9$e5r$1@ger.gmane.org> <20140324215239.GC11533@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140324215239.GC11533@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24/03/14 21:52, Marc MERLIN wrote:
> On Mon, Mar 24, 2014 at 07:17:12PM +0000, Martin wrote:
>> Thanks for the very good summary.
>>
>> So... In very brief summary, btrfs raid5 is very much a work in progress.
> 
> If you know how to use it, which I didn't know do now, it's technically very
> usable as is. The corner cases are in having a failing drive which you can't
> hot remove because you can't write to it.
> It's unfortunate that you can't just "kill" a drive without umounting,
> making the drive disappear so that btrfs can't see it (dmsetup remove
> cryptname for me, so it's easy to do remotely), and remounting in degraded
> mode.

Yes, looking good, but for my usage I need the option to run ok with a
failed drive. So, that's one to keep a development eye on for continued
progress...


>> Question: Is the raid5 going to be seamlessly part of the
>> error-correcting raids whereby raid5, raid6,
>> raid-with-n-redundant-drives are all coded as one configurable raid?
> 
> I'm not sure I parse your question. As far as btrfs is concerned you can
> switch from non raid to raid5 to raid6 by adding a drive and rebalancing
> which effectively reads and re-writes all the blocks in the new format.

There's a big thread a short while ago about using parity across
n-devices where the parity is spread such that you can have 1, 2, and up
to 6 redundant devices. Well beyond just raid5 and raid6:

http://lwn.net/Articles/579034/


>> Also (second question): What happened to the raid naming scheme that
>> better described the btrfs-style of raid by explicitly numbering the
>> number of devices used for mirroring, striping, and error-correction?
> 
> btrfs fi show kind of tells you that if you know how to read it (I didn't
> initially). What's missing for you?

btrfs raid1 at present is always just the two copies of data spread
across whatever number of disks you have. A more flexible arrangement is
to be able to set to have say 3 copies of data and use say 4 disks.
There's a new naming scheme proposed somewhere that enumerates all the
permutations possible for numbers of devices, copies and parity that
btrfs can support. For me, that is a 'killer' feature beyond what can be
done with md-raid for example.


Regards,
Martin



