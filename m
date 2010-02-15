From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 17:26:34 -0500
Message-ID: <4B79CA1A.6070705@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <20100215164255.GG11057@think> <20100215215823.GA3763@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100215215823.GA3763@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Feb 15, 2010 at 11:42:55AM -0500, Chris Mason wrote:
>> We can record the smallest alignment while scanning the devices and just
>> use that.  In general 4K is good enough, although some other database
>> company might be more worried about smaller numbers.
> 
> How is access at 512 byte granularity supposed to work?  With 4k logical
> sector drives that will require a manual read-modify write cycle in
> the direct I/O code, which is counter the intentions.

My understanding is the current 4k drives normally operate in
512 byte read/write access mode unless you set them to run
as 4k only.

In 512 byte mode, they buffer internally on writes.  It is probably
just as safe as any other drive on a power hit, as in anything may
be trash.

btrfs read of 512 byte boundaries is safe because we only write
in 4k boundaries (hopefully we can detect and align on the drive).

jim
