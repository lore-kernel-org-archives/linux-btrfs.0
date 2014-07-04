Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:46062 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaGDOp7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 10:45:59 -0400
From: Russell Coker <russell@coker.com.au>
To: Marc MERLIN <marc@merlins.org>
Reply-To: russell@coker.com.au
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with both 3.15.1 and 3.14?
Date: Sat, 05 Jul 2014 00:45:55 +1000
Message-ID: <3262371.bchVJ2xl3c@xev>
In-Reply-To: <20140704142416.GI26932@merlins.org>
References: <20140704011938.GO11539@merlins.org> <53B6486D.9010006@jp.fujitsu.com> <20140704142416.GI26932@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 4 Jul 2014 07:24:16 Marc MERLIN wrote:
> On Fri, Jul 04, 2014 at 03:23:41PM +0900, Satoru Takeuchi wrote:
> > >Is there any correlation between such problems and BTRFS operations such
> > >as
> > >creating snapshots or running a scrub/balance?
> > 
> > Were you running scrub, Marc?
> 
> Yes, I was due to the other problem I was discussing on the list. I
> wanted to know if scrub would find any problem (it did not).
> I think I'll now try to read every file of every filesystem to see what
> btrfs does (this will take a while, that's around 100 million files).
> 
> But the last times I had this OOM problem with 3.15.1 it was happening
> within 6 hours sometimes, and I was not starting scrub every time the
> system booted, so scrub may be partially responsible but it's not the
> core problem.

It would be a good idea to run a few scrubs and see if this is a repeatable 
problem.  If it's a repeatable problem then it's something to fix regardless 
of whether it's the only issue you have.

> > Marc, do you change
> > 
> >  - software and its setting,
> >  - operations,
> >  - hardware configuration,
> > 
> > or any other, just before detecting first OOM?
> 
> Those are 3 good questions, I asked myself the same thing.
> From what I remember though all I did was going from 3.14 to 3.15.
> However this machine has many cronjobs, it does rsyncs to and from
> remote systems, it has btrfs send/receive going to and from it, and
> snapshots every hour.
> Those are not new, but if any of them changed in a small way, I guess
> they could trigger bugs.

If a scrub can reliably trigger the problem it would be good to test 3.14 for 
the same behavior.  Knowing whether it's a regression would help the 
developers.

> > You have 8GB RAM and there is plenty of swap space.
> 
> Correct.

Even without much swap 8G should be a plenty.  My main workstation has 4G of 
RAM and 6G of swap.  I almost never use more than 3G of swap because the 
system becomes so slow as to be almost unusable when swap gets to 4G (Chromium 
is to blame).  However that is for a 120G non-RAID filesystem.  Presumably a 
RAID array will need some more kernel memory and a larger filesystem will also 
need a little more, but it still shouldn't be that much.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

