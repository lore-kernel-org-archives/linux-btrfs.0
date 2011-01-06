From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 15:07:37 -0800
Message-ID: <201101061507.37698.CACook@quantum-sci.com>
References: <201101060935.14059.CACook@quantum-sci.com> <AANLkTimvyZ-jNCk9FVav8kw8oYUzE1iYpb-5tsuzoz+B@mail.gmail.com> <201101061426.30791.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061426.30791.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 06 January 2011 14:26:30 Carl Cook wrote:
> According To Doyle...

Er, Hoyle...

I am trying to create a multi-device BTRFS system using two identical drives.
I want them to be raid 0 for no redunancy, and a total of 4TB.
But in the wiki it says nothing about using fdisk to set up the drive first.  It just basically says for me to:
mkfs.btrfs -m raid0 /dev/sdc /dev/sdd

Seems to me that for mdadm I had to set each drive as a raid member, assemble the array, then format.  Is this not the case with BTRFS?

Also in the wiki it says "After a reboot or reloading the btrfs module, you'll need to use btrfs device scan to discover all multi-device filesystems on the machine".  Is this not done automatically?  Do I have to set up some script to do this?

