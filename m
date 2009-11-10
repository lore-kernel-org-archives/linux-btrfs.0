From: tsuraan <tsuraan@gmail.com>
Subject: Re: RAID[56] status
Date: Tue, 10 Nov 2009 15:06:41 -0600
Message-ID: <84fb38e30911101306p30633135tdbec8c282692b3f4@mail.gmail.com>
References: <1249553833.568.23.camel@macbook.infradead.org>
	 <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> 3/ The md-raid6 recovery code assumes that there is always at least
> two good blocks to perform recovery.  That makes the current minimum
> number of raid6 members 4, not 3.  (small nit the btrfs code calls
> members 'stripes', in md a stripe of data is a collection of blocks
> from all members).

Why would you use RAID6 on three drives instead of mirroring across
all of them?  I agree it's an artificial limitation, but would anybody
use a RAID6 with fewer than 4 drives?
