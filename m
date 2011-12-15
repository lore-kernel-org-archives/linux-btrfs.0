From: Sander <sander@humilis.net>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Thu, 15 Dec 2011 09:55:30 +0100
Message-ID: <20111215085530.GA31915@attic.humilis.net>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
 <CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
 <CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
 <4EE948AD.9040001@parallels.com>
 <20111215082543.GA12179@attic.humilis.net>
 <4EE9AFD8.1010306@parallels.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE9AFD8.1010306@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

dima wrote (ao):
> >>format the device to
> >>btrfs and use subvolumes instead of your usual partitions (some
> >>/boot restrictions apply). You won't be able to use grub2 though,
> >>but syslinux will work.
> >
> >Grub2 has btrfs support for quite some time now, which you are aware of
> >I assume. Grub2 can't cope with / in a subvolume or something?
> 
> No, btrfs has nothing to do with this. It is just that grub2 cannot
> be installed to a partition-less drive (at least 1 partition is
> needed), while syslinux can.

Ah, wasn't aware of that. Thanks for the info!

	Sander
 
-- 
Humilis IT Services and Solutions
http://www.humilis.net
