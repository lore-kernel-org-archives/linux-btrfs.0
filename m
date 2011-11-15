From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Tue, 15 Nov 2011 11:22:24 +0200
Message-ID: <20111115092224.GA8597@zambezi.lan>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
 <4EC1AB52.2070805@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC1AB52.2070805@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2011 at 06:59:14PM -0500, Phillip Susi wrote:
> I have a fs that started with the default policy of metadata=dup.  I
> added a second device and rebalanced, and so the metadata chunks were
> converted to raid1.  Now I can not remove the second device because
> raid1 requires at least two devices.
> 
> If I understand this patch series correctly, I can use it to manually
> convert those raid1 chunks back to dup, and then remove the second
> device.  It occurs to me though, that in the restripe process, the
> newly created dup chunks can be allocated from either disk still, and
> any that are allocated on the second disk will then need to be
> relocated in order to remove that disk.  This seems inefficient, so I
> was wondering if there is a way to make sure that during the restripe,
> only the disk I intend to keep is allocated from to create the dup
> chunks, and thus avoid the need to relocate when I remove the second disk?

Restriper won't let you do raid1 -> dup transition because dup is only
allowed for a single-spindle FS, so you'll end up with error "btrfs:
unable to start restripe ...".

There is no way to prioritize disks during restripe.  To get dup back
you'll have to convert everything to single, remove the second drive and
then convert metadata from single to dup.

Thanks,

		Ilya
