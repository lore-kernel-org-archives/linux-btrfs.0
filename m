Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59804 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab3DBRAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 13:00:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 20C337C0417
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 11:00:39 -0600 (MDT)
Date: Tue, 2 Apr 2013 13:00:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.ru>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Still getting a lot of -28 (ENOSPC?) errors during balance
Message-ID: <20130402170036.GP1876@localhost.localdomain>
References: <20130402140452.2b71794f@natsu>
 <20130402134626.GO1876@localhost.localdomain>
 <20130402225504.77f42c9a@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130402225504.77f42c9a@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 02, 2013 at 10:55:04AM -0600, Roman Mamedov wrote:
> On Tue, 2 Apr 2013 09:46:26 -0400
> Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > On Tue, Apr 02, 2013 at 02:04:52AM -0600, Roman Mamedov wrote:
> > > Hello,
> > > 
> > > With kernel 3.7.10 patched with "Btrfs: limit the global reserve to 512mb".
> > > (the problem was occuring also without this patch, but seemed to be even worse).
> > > 
> > > At the start of balance:
> > > 
> > > Data: total=31.85GB, used=9.96GB
> > > System: total=4.00MB, used=16.00KB
> > > Metadata: total=1.01GB, used=696.17MB
> > > 
> > > "btrfs balance start -musage=5 -dusage=5" is going on for about 50 minutes
> > > 
> > > Current situation:
> > > 
> > > Balance on '/mnt/r1/' is running
> > > 1 out of about 2 chunks balanced (20 considered),  50% left
> > > 
> > > Data: total=30.85GB, used=10.04GB
> > > System: total=4.00MB, used=16.00KB
> > > Metadata: total=1.01GB, used=851.69MB
> > > 
> > > And a constant stream of these in dmesg:
> > > 
> > 
> > Can you try this out and see if it helps?  Thanks,
> 
> Hello,
> 
> Well that balance has now completed, and unfortunately I don't have a complete
> image of the filesystem from before, to apply the patch and check if the same
> operation goes better this time.
> 
> I'll keep it in mind and will try to test it out if I will get a similar
> situation again on some filesystem.
> 
> Generally what seems to make me run into various problems with balance, is the
> following usage scenario: On an active filesystem (used as /home and root FS),
> a snapshot is made every 30 minutes with an unique (timestamped) name; and once
> a day snapshots from more than two days ago are purged. And it goes like this
> for months.
> 
> Another variant of this, a backup partition, where snapshots are made every six
> hours, and all snapshots are kept for 1-3 months before getting purged.
> 
> I guess this kind of usage causes a lot of internal fragmentation or
> something, which makes it difficult for a balance to find enough free space to
> work with.
> 

Well one thing to keep in mind is that these warnings are truly just warnings,
it finds space and uses it, it's just our internal space reservation
calculations are coming up short so it's letting us know we need to adjust our
math.  So really we need to sit down and adjust how balance does it's
reservation stuff so we can stop these warnings from happening at all, but it
doesn't affect the actual balance other than making it super noisy and slow.
Thanks,

Josef
