Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta4.perrit.net ([194.213.15.92]:45718 "EHLO mta4.perrit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaHXLRb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 07:17:31 -0400
Received: from apia.perrit.net (apia.colo.hnglo.perrit.net [194.0.170.50])
	by mail.perrit.nl (Postfix) with ESMTP id 7B55A1602E1
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 13:08:53 +0200 (CEST)
Date: Sun, 24 Aug 2014 13:08:53 +0200
From: Leen Besselink <leen@consolejunkie.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
Message-ID: <20140824110853.GB22693@apia.perrit.net>
Reply-To: leen@consolejunkie.net
References: <53F7BD8E.10308@floga.de>
 <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net>
 <53F85317.8060900@floga.de>
 <pan$16219$d960b649$52ed1e6$33540704@cox.net>
 <20140823163803.GA9149@hungrycats.org>
 <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2014 at 12:56:47AM +0000, Duncan wrote:
> Zygo Blaxell posted on Sat, 23 Aug 2014 12:38:05 -0400 as excerpted:
> 
> > Consumer SD cards are /terrible/ storage devices.  Always back up all
> > data written to an SD card as soon as possible after writing it, and
> > develop a process to restore the backup to a new SD card conveniently
> > when--not if--the card fails.
> > 
> > Over the years I've burned my way through dozens of SD cards in Pis,
> > Beagles, x86 laptops, USB SD card readers, cameras and cell phones.
> > I have more bad or failed cards than good ones in my collection, but no
> > more than three of any specific model.  Brand, price, and specs don't
> > correlate to success or failure.  Even the good cards wear out after
> > heavy use.  The bad ones fail much faster, and are more likely to give
> > you garbage data instead of properly formed I/O errors as they fail.
> 
> I had read that it was bad, but I didn't know it was /that/ bad.  The 
> ones I've used have tended to be write-once, read for quite some time, 
> often lose (or throw away as obsolete due to tiny size) before I write 
> them again, or at least before I write them half a dozen times, and I've 
> generally not has problems with them doing that, but I wouldn't tend to 
> know about routine rewrite behavior.  Sounds like it's much worse than I 
> might have thought.
> 

tip for basically any Linux filesystem, especially on Flash-based storage and also btrfs:
- use noatime (if you aren't doing that already, don't know if that is the default in btrfs)

" Performance

noatime - as discussed in the mailing list noatime mount option might speed up your file system, especially in case you have lots of snapshots. Each read access to a file is supposed to update its unix access time. COW will happen and will make even more writes. Default is now relatime which updates access times less often (see: http://kerneltrap.org/node/14148). 

Note that noatime will break some applications like the venerable mutt (unless you use Maildir mailboxes). "

https://btrfs.wiki.kernel.org/index.php/Mount_options#Performance

How bad is it ? Well, look at this presentation:

https://www.youtube.com/watch?v=CPEzLNh5YIo

> Thanks.
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
