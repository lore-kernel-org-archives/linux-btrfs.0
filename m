From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Memory leak?
Date: Fri, 08 Jul 2011 16:12:28 -0400
Message-ID: <1310155908-sup-9183@shiny>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110708154123.GA17886@yahoo.fr> <1310141349-sup-9515@shiny> <20110708200412.GG4284@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110708200412.GG4284@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephane Chazelas's message of 2011-07-08 16:04:12 -0400:
> 2011-07-08 12:15:08 -0400, Chris Mason:
> [...]
> > I'd definitely try without -o compress_force.
> [...]
> 
> Just started that over the night.
> 
> I'm running a "dstat -df" at the same time and I'm seeing
> substantive amount of disk writes on the disks that hold the
> source FS (and I'm rsyncing from read-only snapshot subvolumes
> in case you're thinking of atimes) almost more than onto the
> drive holding the target FS!?

These are probably atime updates.  You can completely disable them with
mount -o noatime.

-chris
