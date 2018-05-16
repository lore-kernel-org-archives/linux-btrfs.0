Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47466 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752407AbeEPM6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 08:58:43 -0400
Date: Wed, 16 May 2018 15:03:09 +0200
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
Subject: Re: vm_fault_t conversion, for real
Message-ID: <20180516130309.GB32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de> <20180516112347.GB20670@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516112347.GB20670@bombadil.infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 04:23:47AM -0700, Matthew Wilcox wrote:
> On Wed, May 16, 2018 at 07:43:34AM +0200, Christoph Hellwig wrote:
> > this series tries to actually turn vm_fault_t into a type that can be
> > typechecked and checks the fallout instead of sprinkling random
> > annotations without context.
> 
> Yes, why should we have small tasks that newcomers can do when the mighty
> Christoph Hellwig can swoop in and take over from them?  Seriously,
> can't your talents find a better use than this?

I've spent less time on this than trying to argue to you and Souptick
that these changes are only to get ignored and yelled at as an
"asshole maintainer".  So yes, I could have done more productive things
if you hadn't forced this escalation.
