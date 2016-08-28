Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37651 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbcH1SLr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 14:11:47 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so60428814wmg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 11:10:40 -0700 (PDT)
References: <20160828193559.09534344@jupiter.sol.kaishome.de>
Subject: Re: btrfstune settings
To: linux-btrfs@vger.kernel.org
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <18fb1730-2820-81b1-781e-02ee9435d308@googlemail.com>
Date: Sun, 28 Aug 2016 20:10:38 +0200
MIME-Version: 1.0
In-Reply-To: <20160828193559.09534344@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Try borgbackup, I'm using it very successfully. It is very fast,
> supports very impressive deduplication and compression, retention
> policies, and remote backups - and it is available as a single binary
> version so you can more easily use it for disaster recovery. One
> downside: while it seems to restore nocow attributes, it seems to do it
> in a silly way (it first creates the file, then sets the attributes,
> which of course won't work for nocow). I have not checked that
> extensively, only had to restore once yet.

Wow - this looks like the holy grail I've been waiting for, not sure how
I have missed that up to now. 
Especially the deduplication across several backupped systems on the backup target
is interesting, I originally planned to do that using duperemove on the backup target
to dedupe across the readonly snapshots. 
I'll certainly give borgbackup a spin as soon as I have time to look into it! 

> It's probably not worth the hassle... Wait until you are forced to
> recreate the filesystem or you are having enough spare time to do it.
> However, some settings can be changed for existing filesystems and I
> would simply ignore the fact existing meta data needs to be converted.

Thanks a lot for this hint and also your other points. I think I'll go that way,
comparing a "similar" system with skinny metadata and one without the space usage for metadata
seems not to be different by a noticeable factor. 
Since my systems are SSD only, to avoid unnecessary writes I'll then just wait until
I really need to replay a backup. 

Thanks a lot and best regards, 
	Oliver
