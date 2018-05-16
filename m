Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47485 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752311AbeEPM7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 08:59:18 -0400
Date: Wed, 16 May 2018 15:03:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Souptick Joarder <jrdr.linux@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@lists.orangefs.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org, dri-devel@lists.freedesktop.org,
        lustre-devel@lists.lustre.org, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 14/14] mm: turn on vm_fault_t type checking
Message-ID: <20180516130344.GC32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de> <20180516054348.15950-15-hch@lst.de> <20180516112813.GC20670@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180516112813.GC20670@bombadil.infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 04:28:13AM -0700, Matthew Wilcox wrote:
> On Wed, May 16, 2018 at 07:43:48AM +0200, Christoph Hellwig wrote:
> > Switch vm_fault_t to point to an unsigned int with __bіtwise annotations.
> > This both catches any old ->fault or ->page_mkwrite instance with plain
> > compiler type checking, as well as finding more intricate problems with
> > sparse.
> 
> Come on, Christoph; you know better than this.  This patch is completely
> unreviewable.  Split it into one patch per maintainer tree, and in any
> event, the patch to convert vm_fault_t to an unsigned int should be
> separated from all the trivial conversions.

The whole point is that tiny split patches for mechnical translations
are totally pointless.  Switching the typedef might be worth splitting
if people really insist.
