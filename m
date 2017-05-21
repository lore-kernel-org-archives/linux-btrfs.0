Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:53910 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdEURan (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 13:30:43 -0400
Date: Sun, 21 May 2017 22:30:41 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
Message-ID: <20170521223041.4aa7d0f6@natsu>
In-Reply-To: <CAGqmi77_iaZC0f0BsGWVAzgZnNRvWTHkxvnP=risHa33NGPhGA@mail.gmail.com>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
 <20170520164953.7344-3-nefelim4ag@gmail.com>
 <20170520191400.25202d75@jupiter.sol.kaishome.de>
 <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
 <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net>
 <CAGqmi77_iaZC0f0BsGWVAzgZnNRvWTHkxvnP=risHa33NGPhGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 21 May 2017 19:54:05 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Sorry, but i know about subpagesize-blocksize patch set, but i don't
> understand where you see conflict?
> 
> Can you explain what you mean?
> 
> By PAGE_SIZE i mean fs cluster size in my patch set.

This appears to be exactly the conflict. Subpagesize blocksize patchset would
make it possible to use e.g. Btrfs with 4K block (cluster) size on a MIPS
machine with 64K-sized pages. Would your checking for PAGE_SIZE still be
correct then?

> So if and when subpage patch set would merged, PAGE_SIZE should be
> replaced with sector size, and all continue work correctly.

I guess Duncan's question was why not compare against block size from the get
go, rather than create more places for Chandan to scour through to eliminate
all "blocksize = pagesize" assumptions...

-- 
With respect,
Roman
