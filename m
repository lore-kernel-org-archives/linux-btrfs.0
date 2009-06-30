From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Single disk performance
Date: Tue, 30 Jun 2009 07:02:52 -0400
Message-ID: <20090630110252.GA5963@think>
References: <4A44DB23.5000400@austin.ibm.com> <20090626205659.GD3951@think> <4A458373.4010603@austin.ibm.com> <20090629124149.GF3951@think> <20090629231722.GA19561@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090629231722.GA19561@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2009 at 09:17:22AM +1000, Bron Gondwana wrote:
> On Mon, Jun 29, 2009 at 08:41:49AM -0400, Chris Mason wrote:
> > On Fri, Jun 26, 2009 at 09:26:59PM -0500, Steven Pratt wrote:
> > > 18:40:32 btrfs2 kernel: [ 4459.870613] sd 0:0:1:0: [sdb] Unhandled error 
> > > code
> > > Jun 26 18:40:32 btrfs2 kernel: [ 4459.870640] sd 0:0:1:0: [sdb] Result:  
> > > hostbyte=DID_ABORT driverbyte=DRIVER_OK
> > > Jun 26 18:40:32 btrfs2 kernel: [ 4459.870646] end_request: I/O error,  
> > > dev sdb, sector 103359232
> > >
> > > So still not sure if this is HW, but no other FS has triggered it.
> > 
> > I'm afraid Btrfs can't do this on its own.  It needs to HW, scsi
> > drivers or HW or scsi drivdes ;)
> > 
> > You could try dd if=/dev/sdb of=/dev/zero bs=512 count=1 skip=103359232
> > 
> > Hopefully that will fall over without btrfs helping.
> 
> Surely of=/dev/null ?  Unless you mean to write to the disk at that block
> which would be if=/dev/zero of=/dev/sdb...

Its just habit for me, since /dev/null won't work as if=/dev/null, I
always use /dev/zero with dd.

-chris
