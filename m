Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36810 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaEJA5S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 20:57:18 -0400
Date: Fri, 9 May 2014 17:42:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>, Chris Samuel <chris@csamuel.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bo.li.liu@oracle.com,
        jbacik@fb.com, hugo@carfax.org.uk, dsterba@suse.cz, clm@fb.com
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140510004254.GB9276@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2678329.EOSaIZaHNO@quad>
 <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 10, 2014 at 10:13:43AM +1000, Chris Samuel wrote:
> > Right now, I do see:
> > legolas:~# cat /proc/sys/kernel/tainted
> > 512
> 
> IIUC that's an array of bit flags, and that value means you've had a previous 
> kernel warning at that point according to:
> 
> https://www.kernel.org/doc/Documentation/sysctl/kernel.txt

Yep, I meant to say that I don't have the 'G' now.

It's likely that vbox did 'G' even if I didn't successfully start it,
and even if I haven't had problems with it 'till now, it's a possible
culprit (more details below)

Anyway, it sounds like the FS is toast, there isn't much useful that can
be gleaned from it, so I'll just wipe it and start over. 
I think really my biggest disappointment is that no recovery tools seem
to be able to open the FS now even though it was accessible and
seemingly working well enough when it was read only before I rebooted.

On Fri, May 09, 2014 at 06:00:50PM -0600, Chris Murphy wrote:
> Well I'm sorta dense, so I only find a complete dmesg useful because
> with storage problems it seems much is due to some other problem
> happening earlier. Maybe a fs developer would say "yeah that's not

True, although I didn't find anything earlier that looked relevant.

> good, but we maybe should do better failing gracefully". Call traces
> don't mean much of anything to me, I think the real problem happened
> before this, unless it's strictly a Btrfs bug in which case the
> evidence may be localized in just the trace.

Sure, the corruption could have happened before the cleaner process
uncovered it and then turned my FS read only.
But to be honest, before cleaner ran, the FS worked (I was using it),
after that, it was read only and upon reboot it became unmountable by
anything.
That seems suspect to me :-/
 
> Also you said it went read only overnight but I'm seeing a reference
> here to cleaning up a deleted snapshot? Are you running something
> that's taking and deleting snapshots on a schedule?

Yes, hourly snapshot rotations and hourly btrfs send/receive to my
secondary drive, which is still working as of now and I'm using to type
this now.
(I'll format the SSD and copy things back tonight since I'm worried that
if anything happens to my HD, my laptop will be toast until I get home)

> The G means it's not a proprietary driver involved. You'd have to go
> through a full dmesg to find out what's causing it, but the point of
> the tainted state notification is that the kernel is in a state likely
> no one, or very few, other people are experiencing and any subsequent
> problems are suspect.
 
Mmmh, I did try to start virtualbox, but it didn't start because the
driver was out of date. I did not compile and install the new one yet,
nor actually used virtualbox.

> There are still ZFS corruptions from time to time. And they happen
> even on file systems that get pounded on mercilessly like NTFS, XFS
> and HFS+. Almost always it's not the file system itself, something
> else instigated the problem. Still such mature file systems have bugs
> being found and fixed. So recovery not working itself doesn't surprise
> me, I don't even know what caused the problem.

True. Never had this with ext2/3/4 in 15 years, but as you say, it's
possible.

> I think Btrfs in general is still buyer beware, but that's in the
> category of Not News because I think all free software distributions
> say the same thing, essentially. None of it comes with support or a
> warranty unless you've bought an SLA. If you really suspect a problem
> in 3.14.x that may not yet be fixed in 3.15rc or you don't want to
> run rc kernels is reasonable to run the kernel prior to the current
> one which is 3.13.11. The way kernel fixes work, a fix has to be
> demonstrated in

Right. I'd want to avoid 3.15rc unless someone tells me I really should
be running it.

> Well you think you've been using it successfully for 10 years. If
> you've have exactly 0 cases of any kind of fs corruption in 10 years,
> or can exclude suspend/resume from corruption incident by assurance
> there was a reboot in between the suspend/resume and the corruption,
> then maybe you haven't experienced a problem. But Google is full of
> users who have not merely immediate corruption on suspend/resume

Point taken, thanks.
But not suspending (S3 sleep) on my lapotp isn't exactly practical
either :-/

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
