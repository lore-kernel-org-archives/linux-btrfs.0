From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: What protection does btrfs checksumming currently give? (Was Re: btrfs volume mounts and dies (was Re: Segfault in btrfsck))
Date: Thu, 7 Jan 2010 22:00:32 +0100
Message-ID: <201001072200.34475.johannes.hirte@fem.tu-ilmenau.de>
References: <1262476565.17096.20.camel@phat> <1262888912.6214.20.camel@phat> <4B46362D.3020102@hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Steve Freitas <sflist@ihonk.com>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B46362D.3020102@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 07 Januar 2010 20:29:49 schrieb jim owens:
> Steve Freitas wrote:
> > Hi all,
> >
> > I was under the mistaken impression that btrfs checksumming, in its
> > current default configuration, protected your data from bitrot. It
> > appears this is not the case:
> >
> > On Wed, 2010-01-06 at 18:24 +0100, Johannes Hirte wrote:
> >> Am Mittwoch 06 Januar 2010 16:59:55 schrieb Steve Freitas:
> >>> So please correct me if I have some mistaken assumptions. I thought
> >>> btrfs would be tolerant of that -- if a block failed the checksum test,
> >>> it would reconstruct and remap it.
> >>
> >> Only if enough redundancy is left. And with the default setup btrfs is
> >> only mirroring the metadata not the data.
> >
> > So can someone please tell me what the current state-of-the-art is of
> > data protection with btrfs? Does it differ with single-device versus
> > multiple-device configurations? Is it possible to enable data
> > checksumming now? Under what conditions? And will it do what a naive
> > user would expect it to do, namely, correct for diverse kinds of errors
> > in your storage subsystem? If not, what does it do? Etc...
> 
> First, understand that a checksum only says "this block is good or bad".
> 
> The checksum can not be used to "reconstruct" the data.
> 
> Checksums are present for all btrfs blocks unless you explicitly shut
> them off with mount/ioctl/fcntl options.
> 
> To have a good copy you can use as a replacement block, you must
> use either btrfs raid1 or raid10.  You can use raid1 with 1 drive,
> in a mode called "dup" where both copies are made to that device.
> 
> By default with 1 drive, btrfs uses "dup" for metadata and 1 copy
> (nodup) for file data blocks. To get file data "dup", you just use
> "mkfs.btrfs -d raid1".
> 
> If you have btrfs raid, it will find the good block on a read, but
> AFAIK we don't have tools yet to automatically reallocate the bad one.
> 
> jim

Additionally I repeat the suggestion from Sander, check your drive for bad 
blocks. It sounds very likely that your drive is bad and you will get into 
trouble again with the new created FS. And the Oops you've posted smells like 
a bug in btrfs code.

regards,
  Johannes
