Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kaa.mcnabbs.org ([173.255.195.144]:35055 "EHLO mail.mcnabbs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3AYVWp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 16:22:45 -0500
Date: Fri, 25 Jan 2013 15:22:44 -0600
From: Andrew McNabb <amcnabb@mcnabbs.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stability
Message-ID: <20130125212244.GE4217@mcnabbs.org>
References: <20130125200514.GD4217@mcnabbs.org>
 <20130125203717.GA3257@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130125203717.GA3257@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 03:37:17PM -0500, Josef Bacik wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=903794
> 
> This one is just a allocator warning because the relocator doesn't do the right
> accounting for relocation.  It's just complainig, we need to fix it but it won't
> keep it from working.

I won't worry about this one, then.

> > https://bugzilla.redhat.com/show_bug.cgi?id=904143
> 
> This I'm almost certain (I have to check) was just a result of me making fsync
> faster and forgetting to remove this warn on.  It's fixed upstream.  Again,
> nothing to worry about, but annoying.

Sounds good.

> > This one was triggered when I tried to remove a possibly faulty disk:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=904197
> > 
> 
> Ok this is a bug, I can fix this.  Basically we tried to read from the faulty
> disk, it failed, we read from the other copy, and then tried to write the good
> copy back to the failed disk and when we saw that the IO wasn't actually going
> to go to the bad disk we panic'ed.  Silly but easy enough to understand/fix.

I was a little surprised that this happened after I had already done a
"btrfs dev delete"--is there a way to tell btrfs that a disk really is
gone?

> > With a freshly created filesystem, I got a kernel bug, associated with a
> > hang in most filesystem operations.  This occurred in the middle of
> > ordinary operation and without any sort of hardware-related errors in
> > the kernel logs.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=904223
> > 
> 
> So this is from the fsync stuff, and I'm sure I fixed this somewhere but I can't
> account for where I did it.

Would this also be the cause of the hangs that I'm seeing?  In the end,
a hang with the load rising to 260.10 is the most serious problem.  It's
happened a few times, and it gets temporarily fixed by a reboot, but
then tends to recur fairly soon.

> Can you give btrfs-next a try and see if you can
> still reproduce.  Thanks,

Is there a pre-built RPM for btrfs-next, or what's the best way to try
it out in Fedora without breaking other things?

Thanks for your quick response, and sorry for not responding sooner
(I've been interrupted by a few phone calls).

--
Andrew McNabb
http://www.mcnabbs.org/andrew/
PGP Fingerprint: 8A17 B57C 6879 1863 DE55  8012 AB4D 6098 8826 6868
