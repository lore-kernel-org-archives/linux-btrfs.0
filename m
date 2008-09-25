From: Chris Mason <chris.mason@oracle.com>
Subject: Re: feature request: read/write priorities on multiple
	devices/raid1
Date: Thu, 25 Sep 2008 09:10:38 -0400
Message-ID: <1222348238.7028.31.camel@think.oraclecorp.com>
References: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Kaspar Schleiser <kaspar@schleiser.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-09-25 at 11:19 +0200, Kaspar Schleiser wrote:
> Hello everybody!
> 
> This is my first post on the list, let me know if I'm not following any
> rules.
> 
> What do you think about adding priorities for raid1 arrays?
> 
> For example, always use /dev/ram0 (ramdisk) for reading/writing, but
> nonetheless write everything additionally on /dev/sda1. Restore to
> /dev/ram0 after mount if it is empty.
> 

I don't plan on adding support for non-persistent storage, but there
will be the idea of a fast frontend device that is basically a cache for
slower devices.

-chris


