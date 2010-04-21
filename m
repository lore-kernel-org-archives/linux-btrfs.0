From: Alli Quaknaa <alquaknaa@gmail.com>
Subject: Re: Restoring BTRFS partition
Date: Wed, 21 Apr 2010 07:45:27 +0000
Message-ID: <m2m8c113a261004210045hbba63a41s4f22d5e6fe2e49fe@mail.gmail.com>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
	 <20100420155538.GB3634@laptop.oracle.com>
	 <20100420165049.GA6352@flcl.lan>
	 <r2x8c113a261004201014v71b6bf3dy9535bb9ac2035d6e@mail.gmail.com>
	 <r2o8c113a261004201113gf771574eu35db1b0d916cdfd8@mail.gmail.com>
	 <20100420203017.GA4532@lelouch.nomadic.ncsu.edu>
	 <q2u8c113a261004201525kebe2462agaca1d5fb81773cef@mail.gmail.com>
	 <20100421003045.GA10361@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Alli Quaknaa <alquaknaa@gmail.com>,
	Wengang Wang <wen.gang.wang@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100421003045.GA10361@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Okay,
I've got it working! Huge thanks to everybody and especially to Sean
for identifying that what I was seeing wasn't the real superblock.
So my steps to fix it were (for future generations searching through
the archives):
1. Find the real superblock
2. play with dd ibs=1 skip=nnnnnnn for a while to get an image where
the checksum is at 0x0 and the _BHRfS_ starts at 0x40
3. create the zeros - dd if=/dev/zero of=pad bs=1 count=65536
4. append the data with dd if=/dev/sda of=pad oflag=append
conv=notrunc skip=nnnnnnn ibs=1
~ that's basically it. Converting the skip offset to some bigger units
(512 in my case) helps speed, also some garbage at the end of the file
doesn't seem to cause any harm, so if one doesn't know the exact end
of the partition, it is better to get some more but not necessary to
compute the exact size.
al-Quaknaa
