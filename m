Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:34878 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbcLINtC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 08:49:02 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id F09BF47F966
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Dec 2016 14:45:55 +0100 (CET)
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: Chris Murphy <lists@colorremedies.com>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <CAJCQCtS8zCMYYiedYpkL4bZE0PvEF+sLGG96Uq=Ms1qjd4uCpg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Message-ID: <2d4f5ee2-fc2b-ac48-8f4b-eecf8936b9e1@petaramesh.org>
Date: Fri, 9 Dec 2016 14:45:48 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS8zCMYYiedYpkL4bZE0PvEF+sLGG96Uq=Ms1qjd4uCpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, thanks for your answer,

On 12/09/2016 03:58 AM, Chris Murphy wrote:
> Can you check some bigger files and see if they've become fragmented?
> I'm seeing 1.4GiB files with 2-3 extents reported by filefrag, go to
> over 5000 fragments during dedupe. This is not something I recall
> happening some months ago.

I have checked directories containing VM hard disks, that would be good
candidates. As they're backed up using full rsyncs, I wouldn't expect
them to be heavily fragmented (OTOH the whole BTRFS filesystem is lzo
compressed, and I believe that it may affect the number of extents
reported by filefrag...?)

Anyway this is the number of fragments that I get for a bunch of VMS HD
files which are in the range from a couple GB to about 20 GB.

The number of fragments reported by filefrag : 2907, 2560, 314, 10107

If compression has nothing to do with this, then this is heavy
fragmentation.

Kind regards.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E

