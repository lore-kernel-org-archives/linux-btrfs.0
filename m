Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37103 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932070AbaBUR7W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 12:59:22 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Hard drive hangs after excessive I/O
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAAVQaYDDsfuHu-Lfcjjta48YCP50vZmnGdFM67VQJefnnAfOAg@mail.gmail.com>
Date: Fri, 21 Feb 2014 10:59:19 -0700
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <6A514E1D-EDD7-431D-BF23-9737EAE41DD3@colorremedies.com>
References: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com> <pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net> <CAAVQaYDDsfuHu-Lfcjjta48YCP50vZmnGdFM67VQJefnnAfOAg@mail.gmail.com>
To: Dave <dave@thekilempire.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 21, 2014, at 10:16 AM, Dave <dave@thekilempire.com> wrote:

> On Fri, Feb 21, 2014 at 11:09 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> One other question:  Are you, or perhaps your distro via likely automated
>> script, doing any btrfs snapshotting of the VM-image containing btrfs
>> (sub)volume?
> 
> I haven't done any snapshotting on this machine.
> 
> This problem is pretty easy to reproduce, I spawn about five new
> virtual machines and begin installing Windows XP on them.  The host
> machine obviously slows down quite a bit but the hard drive chatters
> throughout the process.
> 
> The next day I wipe those five machines, spawn five new ones, and
> begin the concurrent installations again.  This time I see the IO
> spurts that I described in my first email; that is, drive thrashes for
> a while, then hangs for a couple minutes…  repeat until host reboot.

Five concurrent VMs for one spinning disk. It sounds like it's seeking to death. The trace shows fsync and datasync so the storage stack is maybe being compelled to write to disk a lot, and not take as much advantage of Btrfs delayed allocation. Is the VM drive a virtio device? What write caching is it configured for? While risky in the face of a crash, I've had much better results with unsafe caching.


Chris Murphy