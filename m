From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 11:37:41 +0200
Message-ID: <4E1EB8E5.3030404@jan-o-sch.net>
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com>	<20110714155620.6e9ac2cc@notabene.brown>	<4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Neil,

On 14.07.2011 08:38, NeilBrown wrote:
> I imagine a new field in 'struct bio' which was normally zero but could be
> some small integer.  It is only meaningful for read.
> When 0 it means "get this data way you like".
> When non-zero it means "get this data using method N", where the different
> methods are up to the device.
> 
> For a mirrored RAID, method N means read from device N-1.
> For stripe/parity RAID, method 1 means "use other data blocks and parity
> blocks to reconstruct data.
> 
> The default for non RAID devices is to return EINVAL for any N > 0.
> A remapping device (dm-linear, dm-stripe etc) would just pass the number
> down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
> some thought.
> 
> So if btrfs reads a block and the checksum looks wrong, it reads again with
> a larger N.  It continues incrementing N and retrying until it gets a block
> that it likes or it gets EINVAL.  There should probably be an error code
> (EAGAIN?) which means "I cannot work with that number, but try the next one".

I like this idea. It comes pretty close to what btrfs is currently doing
(what was the reason for this thread being started, wasn't it?), only
not within struct bio.

The way you describe the extra parameter is input only. I think it would
be a nice add on if we knew which "N" was used when "0" passed for the
request. At least for the RAID1 case, I'd like to see that when I submit
a bio with method (or whatever we call it) "0", it comes back with the
method field set to the value that reflects the method the device
actually used. Obviously, when passing non-zero values, the bio would
have to come back with that value unmodified.

That way, we'll get more control on the retry algorithms and are free to
decide not to use the failed method again, if we like.

Setting "method" on the return path might be valuable not only for
RAID1, but I haven't thought that trough.

-Jan
