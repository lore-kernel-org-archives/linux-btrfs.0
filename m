Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752567AbdKNSvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 13:51:10 -0500
Date: Tue, 14 Nov 2017 19:49:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Read before you deploy btrfs + zstd
Message-ID: <20171114184915.GI28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113225046.GD28899@suse.cz>
 <3013353.6rxLtS64S0@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3013353.6rxLtS64S0@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 08:34:37AM +0100, Martin Steigerwald wrote:
> Hello David.
> 
> David Sterba - 13.11.17, 23:50:
> > while 4.14 is still fresh, let me address some concerns I've seen on linux
> > forums already.
> > 
> > The newly added ZSTD support is a feature that has broader impact than
> > just the runtime compression. The btrfs-progs understand filesystem with
> > ZSTD since 4.13. The remaining key part is the bootloader.
> > 
> > Up to now, there are no bootloaders supporting ZSTD. This could lead to an
> > unmountable filesystem if the critical files under /boot get accidentally
> > or intentionally compressed by ZSTD.
> 
> But otherwise ZSTD is safe to use? Are you aware of any other issues?

No issues from my own testing or reported by other users.
