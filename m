Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42762 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbESULG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 16:11:06 -0400
Date: Tue, 19 May 2015 13:10:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: Let's get a File & Storage miniconf going at LPC2015!
Message-ID: <20150519201055.GD27115@birch.djwong.org>
References: <20150515205825.GC24967@birch.djwong.org>
 <20150519154200.GA2559@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150519154200.GA2559@kmo-pixel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 08:42:00AM -0700, Kent Overstreet wrote:
> On Fri, May 15, 2015 at 01:58:25PM -0700, Darrick J. Wong wrote:
> > We of course are not limited to just those topics -- if there's something
> > you'd really like to discuss with everyone, please add that to the wiki.
> > I realize that mid-August is family vacation time for many people, but
> > those are the constraints the conference has to work with this year.
> > There are fun things to do around Seattle, and that's probably the best
> > time of year to visit.
> 
> It's getting near time for the big bcachefs announcement :)
> 
> Also, stable pages - what's been going on there? Last I heard you were talking
> about using the page migration code to do COW, did anything come of that? I just
> added data checksumming/compression to bcachefs, so that's been fresh on my
> mind.

Yeah.  I never figured out a sane way to migrate pages and keep everything
else happy.  Daniel Phillips is having a go at page forking for tux3; let's
see if the questions about that get resolved.

> Also, there's probably always going to be situations where we're reading or
> writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
> to annotate this - "if you need this to be stable you have to bounce it".
> Otherwise either filesystems/block drivers are going to be stuck bouncing
> everything, or it'll just (continue to be) buggy.

Well, for now there's BIO_SNAP_STABLE that forces the block layer to bounce it,
but right now ext3 is the last user of it, and afaict btrfs is the only other
FS that takes care of stable pages on its own.

--D
