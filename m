From: "Dirk Heinrichs" <dirk.heinrichs@online.de>
Subject: Re: How to mount a subvolume?
Date: Sat, 09 Jan 2010 15:30:39 +0100
Message-ID: <201001091430.39569.dirk.heinrichs@online.de>
References: <20100109150757.1051fd79@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 09 January 2010 14:07:57 Dipl.-Ing. Michael Niederle wrote:
> First thanks alot to Kay and Goffredo!
> 
> But I have another question.
> 
> I read that the current tools cannot display subvolumes, but one should
>  still
> 
> be able to mount them. If I try I get an error message:
> > mount -t btrfs -o subvol=root.2010-01-07 /dev/sda3 /save
> 
> mount: /dev/sda3 is not a valid block device

Does /dev/sda3 actually exist?

Is this a USB device which may have changed its name (now sdb3, or even sdc3) 
after plugging it out and back in again?

Bye...

	Dirk
