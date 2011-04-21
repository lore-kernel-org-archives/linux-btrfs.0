From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: How Snapshots Inter-relate?
Date: Thu, 21 Apr 2011 14:47:25 -0400
Message-ID: <1303411647.25281.2.camel@ayu>
References: <201104211017.52341.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104211017.52341.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-04-21 at 10:17 -0700, CACook@quantum-sci.com wrote:
> I have set up a backup server in the garage which does rsync backups
> of all my servers weekly, and snapshots those backups.  It works
> wonderfully, and I was able to set it up thanks to help from this
> listserv, thank you.
> 
> But I'm accumulating quite a few backups now, unnecessarily.  After a
> couple months I only need a representative one, once a month.  I am
> afraid to delete three of my weekly snapshots out of each month, as
> I'm afraid they're cumulative.  I might end up with nothing valid if
> each builds on the last, forever.

You have nothing to worry about. You can delete any snapshot on btrfs
without losing data from any other snapshot. Each snapshot is completely
independent.

This works because data which is shared between multiple snapshots is
reference counted, and won't be deleted until you remove the last
snapshot that references that data.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

