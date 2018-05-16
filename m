Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47454 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752319AbeEPM5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 08:57:33 -0400
Date: Wed, 16 May 2018 15:01:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christoph Hellwig <hch@lst.de>, Souptick Joarder <jrdr.linux@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
        dri-devel@lists.freedesktop.org, lustre-devel@lists.lustre.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 10/14] vgem: separate errno from VM_FAULT_* values
Message-ID: <20180516130159.GA32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de> <20180516054348.15950-11-hch@lst.de> <20180516095303.GH3438@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516095303.GH3438@phenom.ffwll.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 11:53:03AM +0200, Daniel Vetter wrote:
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Want me to merge this through drm-misc or plan to pick it up yourself?

For now I just want a honest discussion if people really actually
want the vm_fault_t change with the whole picture in place.
