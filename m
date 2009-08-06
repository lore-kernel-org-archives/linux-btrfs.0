From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 16:15:21 +0200
Message-ID: <4A7AE579.1050403@redpill-linpro.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo-lkml@carfax.org.uk>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090806135436.GD3655@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

* Josef Bacik

> This is one of the gotchas of btrfs, there is not proper ENOSPC
> handling, just a few things in place that are a bit conservative to
> make sure you don't panic the box.  Btrfs has seperate zones used for
> data and metadata, and these chunks are allocated in 1gb chunks, so
> you have 212gb of space thats allowed for data use, and 16gb thats
> allowed for metadata use.  By default every 12 (or it may be 8, i 
> forget) chunks we allocate for data, we allocate 1 for metadata,
> which ends up with like 8% of the disk being used for metadata.

Hmm, okay.  I was aware of the fact that it didn't handle the disk
filling up too well, but I didn't know that would cause an issue so long
before the disk has gone full?  I mean, according to df my there's 16 GB
of files on my disk (something I verified with du), while according to
you there should be 212 GB available for that in total.

Has metadata and data _both_ been stored in the 16 GB zone reserved for
metadata, for some reason?  It would make sense that I ran into ENOSPC
in that case, since the metadata-reserved zone now is indeed completely
full.  If I understand you correctly, though, the data is stored in the
212 GB large zone, not the 16 GB large metadata zone - but if that's the
case I don't understand how I could have hit ENOSPC?

> Now in your case you can run btrfsctl -b and it will re-balance the
> space on the drive, and it may give you more space back.  It could
> also possible panic the box, so make sure you are all backed up :).

Thanks for the tipe, but the "-b" option doesn't seem to be present in
btrfsctl (built from a day-fresh git checkout)...?

Best regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
