From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 17:40:54 -0500
Message-ID: <4B79CD76.8050304@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <20100215164255.GG11057@think> <20100215215823.GA3763@infradead.org> <4B79CA1A.6070705@gmail.com> <20100215223246.GA23617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100215223246.GA23617@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Feb 15, 2010 at 05:26:34PM -0500, jim owens wrote:
>> My understanding is the current 4k drives normally operate in
>> 512 byte read/write access mode unless you set them to run
>> as 4k only.
>>
>> In 512 byte mode, they buffer internally on writes.  It is probably
>> just as safe as any other drive on a power hit, as in anything may
>> be trash.
>>
>> btrfs read of 512 byte boundaries is safe because we only write
>> in 4k boundaries (hopefully we can detect and align on the drive).
> 
> There are drives that still have 512 byte logical, but 4k physical
> blocks, this includes all the consumer (SATA) drives.  You can also
> have drives with 4k physical and logical block size, this includes
> many S/390 DASD devices, and also samples of enterprise SAS drives.
> 
> The logical block size is the addressing limit for the OS, so your
> above scenario is correct for the 512 bye logical / 4k physical
> devices, but not the 4k logical / 4k physical devices.  Nevermind
> other corner cases like 2k block size CD-ROM which could in theory
> be used in a read-only btrfs filesystem (very unlikely, but..).
> 
> So no, you really can't go under the bdev_logical_block_size()
> advertized by the device, and that may as well be over 512 bytes.

I agree fully with all of that.  What I did not say is the
current btrfs direct IO code does not go below the drive
logical block size.  If the drive says 4k and the user tries
to read any other multiple, the code returns an error.

The confusion is that detection occurs only when I go to
build the bio because it is there that I know the drive
and extract the drive block size to check alignment.

We only know what drive is being used when we have the
extent info because we can have multiple drives in btrfs.

The early 512 check is the idiot check.

jim 

