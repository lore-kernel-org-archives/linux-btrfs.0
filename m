From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Device files on read-only file systems?
Date: Mon, 15 Aug 2011 10:58:27 -0400
Message-ID: <1313420293-sup-2507@shiny>
References: <4E491AFC.5030403@suse.de>
Content-Type: text/plain; charset=UTF-8
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E491AFC.5030403@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Jeff Mahoney's message of 2011-08-15 09:11:24 -0400:
> Hi all -
> 
> btrfs_permission currently returns -EROFS when the root is set read-only 
> and the open is requested read-write. It doesn't make an exception for 
> device files. Is this intentional?

No, definitely not intentional.

-chris
