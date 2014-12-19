Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:42085 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751156AbaLSQyh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:54:37 -0500
Date: Fri, 19 Dec 2014 10:58:49 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141219165849.GA15104@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca>
 <5493E8B0.1080107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493E8B0.1080107@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> Let me ask some questions.

Sure - thanks for taking an interest.

> On 2014/12/17 11:42, Charles Cazabon wrote:
> > There's roughly 16TB of data in this filesystem (the filesystem is ~17TB).
> > The btrfs filesystem is a simple single volume, no snapshots, multiple
> > devices, or anything like that.  It's an LVM logical volume on top of
> > dmcrypt on top of an mdadm RAID set (8 disks in RAID 6).
> 
> Q1. You mean your Btrfs file system exists on the top of
>     the following deep layers?
> 
> +---------------+
> |Btrfs(single)  |
> +---------------+
> |LVM(non RAID?) |
> +---------------+
> |dmcrypt        |
> +---------------+
> |mdadm RAID set |
> +---------------+

Yes, precisely.  mdadm is used to make a large RAID6 device, which is
encrypted with LUKS, on top of which is layered LVM (for ease of management),
and the btrfs filesystem sits on that.

> Q2. If Q1 is true, is it possible to reduce that layers as follows?
> 
> +-----------+
> |Btrfs(*1)  |
> +-----------+
> |dmcrypt    |
> +-----------+

I don't see how I could do that - I simply have far too much data for a single
disk (not to mention I don't want to risk loss of data from a single disk
failing).  This filesystem has 16.x TB of data in it at present.

> It's because there are too many layers and these have
> the same/similar features and heavy layered file system
> tends to cause more trouble than thinner layered ones
> regardless of file system type.

This configuration is one I've been using for many years.  It's only recently
that I've noticed it being particularly slow with btrfs -- I don't know if
that's because the filesystem has filled up past some critical point, or due
to something else entirely.  That's why I'm trying to figure this out.

> *1) Currently I don't recommend you to use RAID56 of Btrfs.
>     So, if RAID6 is mandatory, mdadm RAID6 is also necessary.

Yes, exactly.  That's why I use mdadm.

> > The speeds I'm seeing (with iotop) fluctuate a lot.  They spend most of
> > the time in the range of 1-3 MB/s, with large periods of time where no IO
> > seems to happen at all, and occasional short spikes to ~25-30 MB/s.
> > System load seems to sit around 10-12 (with only 2 processes reported as
> > running, everything else sleeping) while this happens.
[...]
> > Other filesystems on the same physical disks have no trouble exceeding
> > 100MB/s reads.  The machine is not swapping (16GB RAM, ~8GB swap with 0
> > swap used).
> 
> Q3. They are also consist of the following layers?

Yes, exactly the same configuration.  The fact that I don't see any speed
problems with other filesystems (even in the same LVM volume group) leads me
in the direction of suspecting something to do with btrfs.

> Q4. Are other filesystems also near-full?

No, not particularly.  Now, the btrfs volume in question isn't exactly close
to full - there's more than 500 GB free.  It's just *relatively* full.

> Q5. Is there any error/warning message about
>     Btrfs/LVM/dmcrypt/mdadm/hardwares?

No, no errors or warnings in logs related to the disks, LVM, or btrfs.  I have
historically, with previous kernels, gotten the "task blocked for more than
120 seconds" warnings fairly often, but I haven't seen those lately.

Is there any other info I can collect on this that would help?

Thanks,

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
