Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:43706 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751830Ab1LLHt4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Dec 2011 02:49:56 -0500
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
To: chb@muc.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
	<CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
	<or62i1rxzl.fsf@livre.localdomain>
	<CAO47_-9SCmZGCkKmV93t-Q9X_ffaYs8gY_vaiPxtAPwzRzHQ+w@mail.gmail.com>
	<CAO47_--d2oEHCyMafoBLWfbd1WZsASngBh=4_TNiwrwd+QJkGA@mail.gmail.com>
Date: Mon, 12 Dec 2011 05:47:51 -0200
In-Reply-To: <CAO47_--d2oEHCyMafoBLWfbd1WZsASngBh=4_TNiwrwd+QJkGA@mail.gmail.com>
	(Christian Brunner's message of "Wed, 7 Dec 2011 21:50:04 +0100")
Message-ID: <or62hmut7c.fsf@livre.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Dec  7, 2011, Christian Brunner <chb@muc.de> wrote:

> With this patch applied I get much higher write-io values than without
> it. Some of the other patches help to reduce the effect, but it's
> still significant.

> iostat on an unpatched node is giving me:

> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sda             105.90     0.37   15.42   14.48  2657.33   560.13
> 107.61     1.89   62.75   6.26  18.71

> while on a node with this patch it's
> sda             128.20     0.97   11.10   57.15  3376.80   552.80
> 57.58    20.58  296.33   4.16  28.36


> Also interesting, is the fact that the average request size on the
> patched node is much smaller.

That's probably expected for writes, as bitmaps are expected to be more
fragmented, even if used only for metadata (or are you on SSD?)


Bitmaps are just a different in-memory (and on-disk-cache, if enabled)
representation of free space, that can be far more compact: one bit per
disk block, rather than an extent list entry.  They're interchangeable
otherwise, it's just that searching bitmaps for a free block (bit) is
somewhat more expensive than taking the next entry from a list, but you
don't want to use up too much memory with long lists of
e.g. single-block free extents.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
