Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51233 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3AQOQr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 09:16:47 -0500
Date: Thu, 17 Jan 2013 06:16:43 -0800
From: Marc MERLIN <marc@merlins.org>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130117141643.GA14606@merlins.org>
References: <20130108164958.GA2044@merlins.org> <20130108182541.GE2389@localhost.localdomain> <20130108184603.GG2044@merlins.org> <20130110162009.GF16943@merlins.org> <20130111144952.GA1876@localhost.localdomain> <20130113031212.GI4038@merlins.org> <20130117113122.GW20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130117113122.GW20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:31:22PM +0100, David Sterba wrote:
> On Sat, Jan 12, 2013 at 07:12:12PM -0800, Marc MERLIN wrote:
> > On Fri, Jan 11, 2013 at 09:49:52AM -0500, Josef Bacik wrote:
> > > Probably just related to whatever corruption it is you are seeing.
> >  
> > So I have no corruption afterall, correct?
> > 
> > That's good news, but then it does mean that unclean sudden shutdowns in the wrong place.
> > 
> > I still have a truncated fs_image if someone wants it, and with an
> > apparently uncorrupted FS, btrfs-image is still dying for me:
> > andalfthegreat:~# btrfs-image -c 9 /dev/mapper/cryptroot  /var/tmp/fs_image2
> > Check tree block failed, want=4261896192, have=10797364022063960087
> > Check tree block failed, want=4261896192, have=10797364022063960087
> > Check tree block failed, want=4261896192, have=13996544474027288730
> > Check tree block failed, want=4261896192, have=10797364022063960087
> > Check tree block failed, want=4261896192, have=10797364022063960087
> 
> want= are around 4G, have= numbers are way off, very likely a
> corruption. the number does not translate into a meaningful pattern.

Thanks for your answer, I appreciate it.

So this is the corruption that ends up in my log, and if I remove the log
that happened before the laptop died, then the rest of the filesystem seems
ok and scrub finds nothing wrong.

My very uneducatd guess is that when my SSD craps out, just before my laptop
locks up, it's either responsible for causing that corrupted log to be
written, or there is a bug in btrfs that happens where truncated writes
happen before a device comes of the sata bus.
Either way, I got this bug multiple times with the same device (which I just
replaced yesterday, just in case).

Here's what I've seen so far in case there is a useful pattern.
There is a mix of what I got from btrfs-zero-log and btrfs-image.
I did get the problem more often than just those, but those are the ones I
recorded before zero'ing the log.

Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=7949122546735189447
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629


Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=12746175583536274708
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932

Check tree block failed, want=5212229632, have=12481778023482407252
Check tree block failed, want=5212229632, have=12481778023482407252
Check tree block failed, want=5212229632, have=14440972074482314957
Check tree block failed, want=5212229632, have=12481778023482407252
Check tree block failed, want=5212229632, have=12481778023482407252

Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=12288424950725929455
Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=14419929907352990360

Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=13996544474027288730
Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=10797364022063960087

I'm hopeful this is useful somehow, and hopefully btrfs will stop oops'ing
at boot time, requiring a recovery disk and specialized knowledge to
recover, when this happens.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
