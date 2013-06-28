Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55252 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3F1Q0Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 12:26:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UsbUz-0006Tt-Ub
	for linux-btrfs@vger.kernel.org; Fri, 28 Jun 2013 18:26:13 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 18:26:13 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 18:26:13 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: raid1 inefficient unbalanced filesystem reads
Date: Fri, 28 Jun 2013 17:25:59 +0100
Message-ID: <kqkdeh$3le$1@ger.gmane.org>
References: <kqk4sc$t5d$1@ger.gmane.org> <20130628153418.GW4288@localhost.localdomain> <20130628153910.GM14601@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130628153910.GM14601@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/06/13 16:39, Hugo Mills wrote:
> On Fri, Jun 28, 2013 at 11:34:18AM -0400, Josef Bacik wrote:
>> On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
>>> On kernel 3.8.13:
>>> 
>>> Using two equal performance SATAII HDDs, formatted for btrfs
>>> raid1 for both data and metadata and:
>>> 
>>> The second disk appears to suffer about x8 the read activity of
>>> the first disk. This causes the second disk to quickly get
>>> maxed out whilst the first disk remains almost idle.
>>> 
>>> Total writes to the two disks is equal.
>>> 
>>> This is noticeable for example when running "emerge --sync" or
>>> running compiles on Gentoo.
>>> 
>>> 
>>> Is this a known feature/problem or worth looking/checking
>>> further?
>> 
>> So we balance based on pids, so if you have one process that's
>> doing a lot of work it will tend to be stuck on one disk, which
>> is why you are seeing that kind of imbalance.  Thanks,
> 
> The other scenario is if the sequence of processes executed to do 
> each compilation step happens to be an even number, then the 
> heavy-duty file-reading parts will always hit the same parity of
> PID number. If each tool has, say, a small wrapper around it, then
> the wrappers will all run as (say) odd PIDs, and the tools
> themselves will run as even pids...

Ouch! Good find...

To just test with a:

for a in {1..4} ; do ( dd if=/dev/zero of=$a bs=10M count=100 & ) ; done

ps shows:

martin    9776  9.6  0.1  18740 10904 pts/2    D    17:15   0:00 dd
martin    9778  8.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd
martin    9780  8.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd
martin    9782  9.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd


More to the story from atop looks to be:

One disk maxed out with x3 dd on one cpu core, the second disk
utilised by one dd on the second CPU core...


Looks like using a simple round-robin is pathological for an even
number of disks, or indeed if you have a mix of disks with different
capabilities. File access will pile up on the slowest of the disks or
on whatever HDD coincides with the process (pid) creation multiple...


So... an immediate work-around is to go all SSD or work in odd
multiples of HDDs?!

Rather than that: Any easy tweaks available please?


Thanks,
Martin

