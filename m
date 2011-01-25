From: Chris Mason <chris.mason@Oracle.COM>
Subject: Re: version
Date: Mon, 24 Jan 2011 20:03:24 -0500
Message-ID: <1295917366-sup-2191@think>
References: <BeTmYH9T1uB@helmut.hullen.de> <4D3E012E.4070208@csamuel.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D3E012E.4070208@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Samuel's message of 2011-01-24 17:46:06 -0500:
> On 25/01/11 08:39, Helmut Hullen wrote:
> 
> > Regard the difference between "df" and "btrfs filesystem df".
> 
> I suspect this is fixed in 2.6.38 with the following commit.
> 
> BE WARNED: there are some fairly hairy changes to the pathname
> lookup code to replace the BKL with RCU (not specific to btrfs)
> and so if you are tempted to try it (currently 2.6.38-rc2) only
> do so on a system that you don't care about data on and/or have
> very good incremental backups of which you trust...

Yes, and you can pull in these commits on top of 2.6.37 or 2.6.36 by
pulling in the btrfs-unstable git tree.  But I do agree they should fix
it.

-chris
