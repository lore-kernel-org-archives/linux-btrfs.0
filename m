Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52758 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752482Ab3JBDO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 23:14:27 -0400
Date: Tue, 1 Oct 2013 21:13:55 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
Message-ID: <20131002031355.GA11675@pyropus.ca>
References: <20131001211255.GA5946@pyropus.ca>
 <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
 <20131001234655.GA7937@pyropus.ca>
 <441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> wrote:
> On Oct 1, 2013, at 5:46 PM, Charles Cazabon wrote:
> > 
> >  # btrfs fi df /media/bigbackup/
> >  Data: total=4.53TB, used=4.22TB
> >  System, DUP: total=8.00MB, used=508.00KB
> >  System: total=4.00MB, used=0.00
> >  Metadata, DUP: total=18.00GB, used=17.13GB
> >  Metadata: total=8.00MB, used=0.00
> 
> Since there's only one copy of the data, there isn't a way to repair it, it
> just notes that there is a checksum mismatch.

Ah, I'm not looking to repair the files -- I can recopy the files easily
enough, and rsync will pick up any files whose contents have been corrupted.
I'd like to get the filesystem fixed, though.  i.e., even deleting the
affected files would be fine.  This is a new filesystem to replace my existing
(full) backups filesystem.  The existing backups one is ext4 but this new one
is too big for mkfs.ext4 to handle, so btrfs it is.  I wasn't expecting
problems as I've been running btrfs for other purposes for years.

Am I misunderstanding something here?  It seems to me like btrfsck is telling
me there's problems with the filesystem itself when it continues to report
these checksum errors even after a `btrfsck --repair`.

> I meant 'btrfs fi show'

  Label: 'bigbackup'  uuid: c18dfd04-d931-4269-b999-e94df3b1918c
  Total devices 1 FS bytes used 4.23TB
  devid    1 size 16.37TB used 4.56TB path /dev/dm-9

> > As I say, it's 8 disks (yes, SATA).  What info exactly do you want about
> > the disks and ports? 
> 
> Looking for problems that relate to this one.
> 
> When was the last time you did a scrub on the md device? And what was the
> result?

It's a brand new array.  The initial sync is actually still going on (about
half complete; it'll take several days to initialize an array this size on
this hardware).

So in short, the underlying array is clean.

> What is the 'smartctl -l scterc /dev/sdX' result for one of the drives?

  Warning: device does not support SCT Error Recovery Control command

> This sounds to me like it could be a bit flip, and btrfs is catching it but
> doesn't have a 2nd copy of the data. Just a guess.

If one of the disks flipped a bit, it would be caught at the md RAID-6 level,
no?

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
