Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39015 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdKNTnM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 14:43:12 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Read before you deploy btrfs + zstd
Date: Tue, 14 Nov 2017 20:43:11 +0100
Message-ID: <60431644.3D68ycWrM5@merkaba>
In-Reply-To: <20171114184915.GI28899@twin.jikos.cz>
References: <20171113225046.GD28899@suse.cz> <3013353.6rxLtS64S0@merkaba> <20171114184915.GI28899@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba - 14.11.17, 19:49:
> On Tue, Nov 14, 2017 at 08:34:37AM +0100, Martin Steigerwald wrote:
> > Hello David.
> > 
> > David Sterba - 13.11.17, 23:50:
> > > while 4.14 is still fresh, let me address some concerns I've seen on
> > > linux
> > > forums already.
> > > 
> > > The newly added ZSTD support is a feature that has broader impact than
> > > just the runtime compression. The btrfs-progs understand filesystem with
> > > ZSTD since 4.13. The remaining key part is the bootloader.
> > > 
> > > Up to now, there are no bootloaders supporting ZSTD. This could lead to
> > > an
> > > unmountable filesystem if the critical files under /boot get
> > > accidentally
> > > or intentionally compressed by ZSTD.
> > 
> > But otherwise ZSTD is safe to use? Are you aware of any other issues?
> 
> No issues from my own testing or reported by other users.

Thanks to you and the others. I think I try this soon.

Thanks,
-- 
Martin
