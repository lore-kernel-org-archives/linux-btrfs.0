From: Chris Mason <chris.mason@oracle.com>
Subject: Re: postgresql activity causes crash, 2.6.36.1
Date: Mon, 08 Nov 2010 18:49:54 -0500
Message-ID: <1289260107-sup-5774@think>
References: <225116.26295.qm@web51906.mail.re2.yahoo.com> <1289224688-sup-3338@think> <303125.91065.qm@web51903.mail.re2.yahoo.com> <1289248602-sup-5744@think> <39229.10625.qm@web51905.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Brian Neu <proclivity76@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <39229.10625.qm@web51905.mail.re2.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Great, this is a known bug in the O_DIRECT code.  I'll fix it up
tomorrow morning.

The problem is that we're allowing bios that are too large for btrfs to
deal with.  It doesn't show any corruption in the FS.

-chris

Excerpts from Brian Neu's message of 2010-11-08 17:50:17 -0500:
> > No, this is perfect ;) The only problem is that we're missing the  stuff
> 
> > at the very top of the oops.  That's the part that explains why  it
> > oopsed.  The stuff in this png is great, but it only shows where  it
> > oopsed.
> > 
> > -chris
> 
> 
> I changed the kernel line in grub.conf for 1280x1024, rebooted, and  
> orchestrated another crash for you.  This time I noted that db activity  was 
> necessary to cause the crash.
> 
> not my steadiest camera work, but still legible
