From: "yoosty69@netzero.com" <yoosty69@netzero.com>
Subject: Re: btrfs Bug?
Date: Wed, 7 Apr 2010 00:37:12 GMT
Message-ID: <20100406.173712.8149.0@webmail08.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: yoosty69@netzero.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After reading around a bit on the btrfs wiki (the Getting_Started page and Gotchas page specifically) I found that I might be able to at least capture an image of the drive in case any devs needed to take a look at it; unfortunately btrfs-image failed with the same error.
I deduced that a repair of the FS requires it to be mounted with "mount -o degraded <dev> <mount_point>", but trying to mount in degraded mode also failed with the same error.
Not too sure where to go from here except shedding a tear for the few files that I didn't have backed up and starting over (or returning the drive? badblocks didn't return anything however..).


   Justin


____________________________________________________________
Get Free Email with Video Mail & Video Chat!
http://www.netzero.net/freeemail?refcd=NZTAGOUT1FREM0210
