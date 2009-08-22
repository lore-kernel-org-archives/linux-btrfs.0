From: tsuraan <tsuraan@gmail.com>
Subject: Re: RAID[56] with arbitrary numbers of "parity" stripes.
Date: Sat, 22 Aug 2009 10:34:03 -0500
Message-ID: <84fb38e30908220834pab3f891we9ca7114a16988c0@mail.gmail.com>
References: <1249502665.23206.5.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1249502665.23206.5.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

> We discussed using the top bits of the chunk type field field to store a
> number of redundant disks -- so instead of RAID5, RAID6, etc., we end up
> with a single 'RAID56' flag, and the amount of redundancy is stored
> elsewhere.

Is there any sort of timeline for RAID5/6 support in btrfs?  I
currently have 8 drives in a zfs-fuse RAIDZ2 (RAID6) configuration,
and I'd love to see how btrfs compares to that, once it's ready.
