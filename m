Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbEGOO1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 10:14:27 -0400
Date: Thu, 7 May 2015 16:14:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: quwenruo@cn.fujitsu.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        anonymous_temp_mail@yahoo.co.jp
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
Message-ID: <20150507141424.GD23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
 <5549CCD8.2010000@cn.fujitsu.com>
 <CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
 <5549DF66.5090900@cn.fujitsu.com>
 <CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com>
 <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 11:05:20AM -0600, Chris Murphy wrote:
> Ok so now that my mea culpa is out of the way, I'm actually wondering
> why non-root users can't do certain btrfs tasks when they're read-only
> commands.
> 
> [chris@f22m ~]$ btrfs fi show
> ERROR: could not open /dev/sda7   ##this is new it wasn't doing this last night
> btrfs-progs v4.0
> [chris@f22m ~]$ btrfs fi df /
> Data, single: total=4.00GiB, used=3.57GiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=1.01GiB, used=198.30MiB
> GlobalReserve, single: total=80.00MiB, used=0.00B
> [chris@f22m ~]$ btrfs fi usage /
> WARNING: can't read detailed chunk info, RAID5/6 numbers will be
> incorrect, run as root
> WARNING: can't get filesystem info from ioctl(FS_INFO), run as root
> ERROR: couldn't get space info on '/' - Operation not permitted
> 
> 
> I think usage is more useful than df for users, and contains largely
> the same information as df + show, so I think all three should be
> non-root user usable.

The raid56 info is obtained through the search ioctl that's available
only to root (as Hugo explained in another mail).

The FS_INFO ioctl is unnecessarily root-only in kernels up to 3.15.
