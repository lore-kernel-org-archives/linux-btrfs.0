From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to a filesystem
Date: Thu, 30 Sep 2010 15:47:37 +0200
Message-ID: <87tyl7uyva.fsf@basil.nowhere.org>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
	<20100928232513.GA20629@infradead.org>
	<20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
	<20100929001954.GA9182@tango.0pointer.de>
	<4CA2E9CD.5090700@redhat.com>
	<AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
	<20100929234327.GA8401@infradead.org>
	<AANLkTi=tzfR2RQzXP6MbzzZmxdpqPO=WQPFs4QSGseHi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=tzfR2RQzXP6MbzzZmxdpqPO=WQPFs4QSGseHi@mail.gmail.com>
	(Kay Sievers's message of "Thu, 30 Sep 2010 09:43:00 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Kay Sievers <kay.sievers@vrfy.org> writes:
>
> Yeah, we thought about that too, but a btrfs mount does not show up as
> a block device, like md/dm, so there is no place for a slaves/
> directory in /sys with the individual disks listed. How could be solve
> that? Create some fake blockdev for every btrfs mount,  but that can't
> be used to read/write raw blocks?

You could simply create a new class for btrfs? (or maybe a generic
"compound" class)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
