Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33220 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbbLWUHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:07:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBphD-0002eQ-0A
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 21:07:39 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:07:38 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:07:38 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Wed, 23 Dec 2015 21:07:32 +0100
Message-ID: <567AFF04.1030200@gmx.de>
References: <n5du09$9rn$1@ger.gmane.org> <1527885.5NheBqth0k@merkaba> <n5e139$r1h$1@ger.gmane.org> <CADfjVrhQCxuggAzSKMcv8m6XJFvoCy4DVueSbrCX19KV-oHAPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <CADfjVrhQCxuggAzSKMcv8m6XJFvoCy4DVueSbrCX19KV-oHAPA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.12.2015 um 20:45 schrieb Noah Massey:
> On Wed, Dec 23, 2015 at 6:38 AM, Neuer User <auslands-kv@gmx.de> wrote:
> I believe Martin's concern is two-fold:
> 
> The first, major issue, concerns the default writeback cache mode,
> which makes the SSD a single point of failure.
> (in writeback mode, a write to a block that is cached will go only to
> the cache and the block
> will be marked dirty in the metadata.) If the SSD fails with dirty
> data in the cache which has not been flushed to the backing devices,
> the filesystem may be in a unrecoverable state, because writes which
> BTRFS was told had succeeded are not present on disk.
Ok, I see. Would it help, if the cache were set to writethrough then? In
this case the data on the hdds should be always ok, right? (At least as
long as the hdds are fine.)
> 
> The second potential issue is that if the SSD performs internal
> deduplication, the two copies of cached data (contents on drive 1,
> content on drive 2) may actually be a reference to the same bits of
> internal storage, meaning a single corruption will affect both cached
> copies. If in writeback, then corrupted data could flush down to both
> disks. I'm not sure what would happen in writethrough.
> 
Understood. However, do SSDs really do automatic deduplication? I might
be completely wrong here, but that sounds to be a rather complex
mechanism, requiring lots of RAM to deduplicate 100 GB. I wouldn't have
thought that typical SSDs include that?

> ~ Noah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


