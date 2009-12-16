From: regomodo <regomodo@googlemail.com>
Subject: Re: BTRFS major fault
Date: Wed, 16 Dec 2009 20:34:06 +0000
Message-ID: <200912162034.06590.regomodo@googlemail.com>
References: <200912161829.38785.regomodo@googlemail.com> <20091216193748.GF3322@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091216193748.GF3322@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 16 December 2009 19:37:48 Chris Mason wrote:
> On Wed, Dec 16, 2009 at 06:29:38PM +0000, regomodo wrote:
> > I was running linux-kernel-2.6.32.1 and suspended my system using
> > "hibernate-ram".
> >
> > When I resumed the system was OK for a moment then froze up. I managed to
> > get to tty1 easily and saw errors relating to btrfs.
> > I did not manage to get the error down but it had an abbreviation of
> > checksum and said maybe something about an inode/node.
> 
> These show disk corruption, which is also what the btrfsck errors
> report.  How exactly are you doing suspend?
> 
>From the command-line, as root, with "hibernate-ram".

