From: David Pottage <david@electric-spoon.com>
Subject: Re: Safe fsck / consistent backup while mounted
Date: Sun, 05 Jun 2011 08:58:57 +0100
Message-ID: <4DEB3741.6010701@electric-spoon.com>
References: <201106041225.56028.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106041225.56028.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/06/11 11:25, Martin Steigerwald wrote:

> > Now I thought about a way to safely backup a MySQL or other database - 
> > without long service interruption:
> >
> > - Tell DB to turn itself into consistent state and freeze there
> > - sync / btrfs filesystem sync ; fsfreeze -f /mountpoint
> > - btrfs subvolume snapshot
> > - fsfreeze -u /mountpoint
> > - Tell DB to continue business as usual
> >
> > My questions are:
> >
> > 1) Would this work?
It should do, and it is common way to backup or check high availability
databases.

About a year ago I was responsible for a database backup and checking
system at a large blue chip company. The database was Informix, and it's
files where kept on a Netapp storage appliance, but the basic principle
was the same.

The database was frozen temporarily, a snapshot taken, and then the
database un-frozen. The snapshot was then made writable, and was then
mounted by the database engine and checked for errors. The live database
is only off line for a few seconds so the users don't notice, especaly
if the snapshot is taken at night when there are few users.

-- David Pottage

