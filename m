Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:36888 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEWDyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 23:54:50 -0400
From: Russell Coker <russell@coker.com.au>
To: ashford@whisperpc.com
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
Date: Fri, 23 May 2014 13:54:46 +1000
Message-ID: <7834850.9NHERJjFOs@xev>
In-Reply-To: <ac1e9fe46f993235f30b4c003210dec8.squirrel@webmail.wanet.net>
References: <2308735.51F3c4eZQ7@xev> <1795587.Ol58oREtZ7@xev> <ac1e9fe46f993235f30b4c003210dec8.squirrel@webmail.wanet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 May 2014 15:09:40 ashford@whisperpc.com wrote:
> You've addressed half of the issue.  It appears that the metadata is
> normally a bit over 1% using the current methods, but two samples do not
> make a statistical universe.  The good news is that these two samples are
> from opposite extremes of usage, so I expect they're close to where the
> overall average would end up.  I'd like to see a few more samples, from
> other usage scenarios, just to be sure.
> 
> If the above numbers are normal, adding ditto blocks could increase the
> size of the metadata from 1% to 2% or even 3%.  This isn't a problem.
> 
> What we still don't know, and probably won't until after it's implemented,
> is whether or not the addition of ditto blocks will make the space
> allocation worse.

I've been involved in many discussions about filesystem choice.  None of them 
have included anyone raising an issue about ZFS metadata space usage, probably 
most ZFS users don't even know about ditto blocks.

The relevant issue regarding disk space is the fact that filesystems tend to 
perform better if there is a reasonable amount of free space.  The amount of 
free space for good performance will depend on filesystem, usage pattern, and 
whatever you might define as "good performance".

The first two Google hits on searching for recommended free space on ZFS 
recommended using no more than 80% and 85% of disk space.  Obviously if "good 
performance" requires 15% of free disk space then your capacity problem isn't 
going to be solved by not duplicating metadata.  Note that I am not aware of 
the accuracy of such claims about ZFS performance.

Is anyone doing research on how much free disk space is required on BTRFS for 
"good performance"?  If a rumor (whether correct or incorrect) goes around 
that you need 20% free space on a BTRFS filesystem for performance then that 
will vastly outweigh the space used for metadata.

> > The ZFS design involves ditto blocks being spaced apart due to the fact
> > that corruption tends to have some spacial locality.  So you are adding
> > an extra seek.
> > 
> > The worst case would be when you have lots of small synchronous writes,
> > probably the default configuration of Maildir delivery would be a good
> > case.
> 
> Is there a performance test for this?  That would be helpful in
> determining the worst-case performance impact of implementing ditto
> blocks, and probably some other enhancements as well.

http://doc.coker.com.au/projects/postal/

My Postal mail server benchmark is one option.  There are more than a few 
benchmarks of synchronous writes of small files, but Postal uses real world 
programs that need such performance.  Delivering a single message via a 
typical Unix MTA requires synchronous writes of two queue files and then the 
destination file in the mail store.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

