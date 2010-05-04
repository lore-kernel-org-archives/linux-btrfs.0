From: Chris Mason <chris.mason@oracle.com>
Subject: Re: raild[56] again
Date: Tue, 4 May 2010 11:11:57 -0400
Message-ID: <20100504151157.GS3447@think>
References: <14154949.31.1272916930325.JavaMail.root@zimbra>
 <1272985749.31892.5621.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1272985749.31892.5621.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 04, 2010 at 04:09:09PM +0100, David Woodhouse wrote:
> On Mon, 2010-05-03 at 22:02 +0200, Roy Sigurd Karlsbakk wrote:
> > Is raid[56] coming to btrfs? There was some talk about it a year back
> > or so, but I haven't seen anything yet....
> 
> Um, there was some talk about it about four days ago. You even
> participated in that thread!
> 
> As it stands, it has the traditional 'write hole' problem -- when you
> overwrite _part_ of a stripe, you have to update the parity block(s) too
> and you have a short period of time where the parity doesn't match the
> actual data. If you get a crash followed by a disk failure during that
> period of time, you get data loss.
> 
> The solution is always to write a full stripe (across all the disks in
> the set). Chris said he'd sort that out in the upper layers of btrfs,
> about which I know little. We've been waiting a while for that.

Yeah, I've got it nailed down for data and metadata here, and I'm
integrating all these development patches into one branch (O_DIRECT
etc, raid, zheng's work).

-chris
