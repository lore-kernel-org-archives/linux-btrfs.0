Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51900 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933260AbcILOEc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:04:32 -0400
Subject: Re: Is stability a joke?
To: Michel Bouissou <michel.bouissou@umontpellier.fr>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <57D51BF9.2010907@online.no> <20160911130221.GE7138@carfax.org.uk>
 <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com> <13278997.DcMfnd2pLu@vajra>
Cc: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <0e96e108-0444-2ba1-80e5-2b1f34d2e087@bouton.name>
Date: Mon, 12 Sep 2016 16:04:29 +0200
MIME-Version: 1.0
In-Reply-To: <13278997.DcMfnd2pLu@vajra>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 12/09/2016 14:59, Michel Bouissou wrote:
>  [...]
> I never had problems with lzo compression, although I suspect that it (in 
> conjuction with snapshots) adds much fragmentation that may relate to the 
> extremely bad performance I get over time with mechanical HDs.

I had about 30 btrfs filesystems on 2TB drives for a Ceph cluster with
compress=lzo and a background process which detected files recently
written to and defragmented/recompressed them using zlib when they
reached an arbitrary fragmentation level (so the fs was a mix of lzo,
zlib and "normal" extents).

With our usage pattern, our Ceph cluster is faster with compress=zlib
instead of the lzo then zlib mechanism (which tried to make writes
faster but was in fact counterproductive) so we made the switch to
compress=zlib this winter.

On these compress=lzo filesystems, at least 12 where often (up to
several times a week) corrupted by defective hardware controllers. I
never had any crash related to BTRFS under these conditions (at the time
with late 3.19 and 4.1.5 + Gentoo patches kernels). Is there a bug
somewhere open with kernel version affected and the kind of usage that
could reproduce any lzo specific problem (or any problem made worse by
lzo) ?

Lionel
