From: Sage Weil <sage@newdream.net>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 09:23:09 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1110250918140.20108@cobra.newdream.net>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
 <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net> <20111025102330.GA18415@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christian Brunner <chb@muc.de>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111025102330.GA18415@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 25 Oct 2011, Christoph Hellwig wrote:
> On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
> > > - When I run ceph with btrfs snaps disabled, the situation is getting
> > > slightly better. I can run an OSD for about 3 days without problems,
> > > but then again the load increases. This time, I can see that the
> > > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing more work
> > > than usual.
> > 
> > FYI in this scenario you're exposed to the same journal replay issues that 
> > ext4 and XFS are.  The btrfs workload that ceph is generating will also 
> > not be all that special, though, so this problem shouldn't be unique to 
> > ceph.
> 
> What journal replay issues would ext4 and XFS be exposed to?

It's the ceph-osd journal replay, not the ext4/XFS journal... the #2 
item in

	http://marc.info/?l=ceph-devel&m=131942130322957&w=2

sage
