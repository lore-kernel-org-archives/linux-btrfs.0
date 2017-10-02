Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:47873 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdJBUTc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 16:19:32 -0400
To: linux-btrfs@vger.kernel.org
Subject: Re: Why do full balance and deduplication reduce available free  space?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Oct 2017 22:19:32 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
In-Reply-To: <20171002213509.50a68609@jupiter.sol.kaishome.de>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
 <20171002213509.50a68609@jupiter.sol.kaishome.de>
Message-ID: <498fe60d8c78ad7e882726214ce5b844@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il 2017-10-02 21:35 Kai Krakow ha scritto:
> Besides defragging removing the reflinks, duperemove will unshare your
> snapshots when used in this way: If it sees duplicate blocks within the
> subvolumes you give it, it will potentially unshare blocks from the
> snapshots while rewriting extents.
> 
> BTW, you should be able to use duperemove with read-only snapshots if
> used in read-only-open mode. But I'd rather suggest to use bees
> instead: It works at whole-volume level, walking extents instead of
> files. That way it is much faster, doesn't reprocess already
> deduplicated extents, and it works with read-only snapshots.
> 
> Until my patch it didn't like mixed nodatasum/datasum workloads.
> Currently this is fixed by just leaving nocow data alone as users
> probably set nocow for exactly the reason to not fragment extents and
> relocate blocks.

Bad Btrfs Feature Interactions: btrfs read-only snapshots (never tested, 
probably wouldn't work well)

Unfortunately it seems that bees doesn't support read-only snapshots, so 
it's a no way.

P.S.
I tried duperemove with -A, but besides taking much longer it didn't 
improve the situation.
Are you sure that the culprit is duperemove? AFAIK it shouldn't unshare 
extents...

Niccolò
