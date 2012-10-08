Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34676 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2JHQJg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 12:09:36 -0400
Date: Mon, 8 Oct 2012 12:09:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, getting darn slower everyday
Message-ID: <20121008160933.GA2259@localhost.localdomain>
References: <50714AC8.4010100@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <50714AC8.4010100@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 07, 2012 at 03:26:32AM -0600, Swâmi Petaramesh wrote:
> Hi,
> 
> I have 4 machines, all converted to BTRFS about 6 months ago, now all
> running Ubuntu Quantal with kernel 3.5.0-17
> 
> The matter is that all these machines are now getting slower and slower
> everyday, every disk access causing the disk to be 100% busy for long
> periods, to the point that I'm now seriously considering migrating
> everything back to ext4...
> 
> From the start BTRFS was "not very fast", still satisfactory, but now it
> becomes truly unusable.
> 
> On one machine, I know have a typical complete boot time to a usable GUI
> that is over 4 minutes, with the HD still very busy for a couple more
> minutes afterwards, where it used to be around 35-40 seconds in ext4 !
> 
> Is there anything I could do to speed things back (without losing all my
> snapshots or doubling the size of data on disk)...?
> 
> I already had made the move back from BTRFS to ext4 about 18 months ago,
> I found it had improved so was back to BTRFS, and I wouldn't have to
> revert back again :-/
> 
> Any advice or help greatly appreciated.
> 

Can you get sysrq+w when you are seeing slowness?  Usually bootup slow times
means you don't have space_cache enabled or your cache is being evicted for some
reason, can you check dmesg after bootup for messages related to space cache?
Thanks,

Josef
