From: Chris Mason <chris.mason@oracle.com>
Subject: Re: your mail
Date: Thu, 1 Mar 2012 09:26:25 -0500
Message-ID: <20120301142625.GW5054@shiny>
References: <1330599216.71336.YahooMailNeo@web30703.mail.mud.yahoo.com>
 <1330605662.98275.YahooMailNeo@web30706.mail.mud.yahoo.com>
 <20120301125814.GA4334@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: bella tk <enat_love1@yahoo.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120301125814.GA4334@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2012 at 01:58:14PM +0100, David Sterba wrote:
> On Thu, Mar 01, 2012 at 04:41:02AM -0800, bella tk wrote:
> > I want to use btrfs defrag tool but before that i want to know how
> > much the disk is fragmented. I have tried to use filefrag but it gives
> > me FIBMAP:invalid argument for many times.
> 
> The only way to trigger FIBMAP on btrfs is to run filefrag with -B
> option, but it should use FIEMAP by default and it works. With -v option
> it'll list all extents.

We actually disabled bmap to keep the swap code from remembering fixed
offsets for btrfs files.  The only way to get the mapping is with
fiemap.

The defrag ioctl won't bother defragging files that are not fragmented.

-chris
