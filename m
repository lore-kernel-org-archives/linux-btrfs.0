Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48802 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeEPRaR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 13:30:17 -0400
Date: Wed, 16 May 2018 19:34:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Souptick Joarder <jrdr.linux@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
        dri-devel@lists.freedesktop.org, lustre-devel@lists.lustre.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 14/14] mm: turn on vm_fault_t type checking
Message-ID: <20180516173445.GA6088@lst.de>
References: <20180516054348.15950-1-hch@lst.de> <20180516054348.15950-15-hch@lst.de> <20180516150829.GA4904@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516150829.GA4904@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 08:08:29AM -0700, Darrick J. Wong wrote:
> Uh, we're changing function signatures /and/ redefinining vm_fault_t?
> All in the same 90K patch?
> 
> I /was/ expecting a series of "convert XXXXX and all callers/users"
> patches followed by a trivial one to switch the definition, not a giant
> pile of change.  FWIW I don't mind so much if you make a patch
> containing a change for some super-common primitive and a hojillion
> little diff hunks tree-wide, but only one logical change at a time for a
> big patch, please...
> 
> I quite prefer seeing the whole series from start to finish all packaged
> up in one series, but wow this was overwhelming. :/

Another vote to split the change of the typedef, ok I get the message..
