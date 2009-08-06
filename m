From: Josef Bacik <josef@redhat.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 10:27:50 -0400
Message-ID: <20090806142750.GE3655@dhcp231-156.rdu.redhat.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo-lkml@carfax.org.uk>
To: Tore Anderson <tore.anderson@redpill-linpro.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7AE579.1050403@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2009 at 04:15:21PM +0200, Tore Anderson wrote:
> Hello Josef,
> 
> * Josef Bacik
> 
> > This is one of the gotchas of btrfs, there is not proper ENOSPC
> > handling, just a few things in place that are a bit conservative to
> > make sure you don't panic the box.  Btrfs has seperate zones used for
> > data and metadata, and these chunks are allocated in 1gb chunks, so
> > you have 212gb of space thats allowed for data use, and 16gb thats
> > allowed for metadata use.  By default every 12 (or it may be 8, i 
> > forget) chunks we allocate for data, we allocate 1 for metadata,
> > which ends up with like 8% of the disk being used for metadata.
> 
> Hmm, okay.  I was aware of the fact that it didn't handle the disk
> filling up too well, but I didn't know that would cause an issue so long
> before the disk has gone full?  I mean, according to df my there's 16 GB
> of files on my disk (something I verified with du), while according to
> you there should be 212 GB available for that in total.
> 
> Has metadata and data _both_ been stored in the 16 GB zone reserved for
> metadata, for some reason?  It would make sense that I ran into ENOSPC
> in that case, since the metadata-reserved zone now is indeed completely
> full.  If I understand you correctly, though, the data is stored in the
> 212 GB large zone, not the 16 GB large metadata zone - but if that's the
> case I don't understand how I could have hit ENOSPC?
>

Ooookay, now that I'm awake lets try this again :).  You are right, I thought it
was 212GB used, not 16GB used.  Something has gone horribly wrong, btrfs seems
to think thats all the space it can use.  The command you need to use is
btrfs-vol -b.  Please try that and see if it behaves better.  Before you run
that please do a btrfs-show and post the output, I'd like to see how big the fs
thinks its supposed to be.  Thanks,

Josef
