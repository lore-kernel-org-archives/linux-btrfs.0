From: Jeff Schroeder <jeffschroed@gmail.com>
Subject: Re: feature request: read/write priorities on multiple devices/raid1
Date: Thu, 25 Sep 2008 04:27:08 -0700
Message-ID: <16745255-0583-4D72-8AA4-B86E67698898@gmail.com>
References: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
Mime-Version: 1.0 (iPhone Mail 5F136)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Kaspar Schleiser <kaspar@schleiser.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sep 25, 2008, at 2:19 AM, "Kaspar Schleiser" <kaspar@schleiser.de>  
wrote:

> Hello everybody!
>
> This is my first post on the list, let me know if I'm not following  
> any
> rules.
>
> What do you think about adding priorities for raid1 arrays?
>
> For example, always use /dev/ram0 (ramdisk) for reading/writing, but
> nonetheless write everything additionally on /dev/sda1. Restore to
> /dev/ram0 after mount if it is empty.
>
> Or use /dev/sd[c-h], maybe a raid 0 of fast read access/slow random  
> write
> flash media for reading, but /dev/sda1 (a reasonably fast HD) for  
> writing.
> make sure written data get's replicated on the raid0.
>
> The linux md driver supports that in some way using the --write- 
> mostly and
> --write-behind options, but that's not very flexible.
>
> Cheers
> Kaspar Schleiser
>

Sounds roughly like a project posted to LKML not that long ago by  
Daniel Phillips. Google "LKML Daniel Phillips ramback".

Sent from my iPhone 
