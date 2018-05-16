Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57891 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752038AbeEPLQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 07:16:12 -0400
Date: Wed, 16 May 2018 13:13:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
        dri-devel@lists.freedesktop.org, lustre-devel@lists.lustre.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/14] btrfs: separate errno from VM_FAULT_* values
Message-ID: <20180516111329.GZ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516054348.15950-1-hch@lst.de>
 <20180516054348.15950-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516054348.15950-7-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 07:43:40AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Sterba <dsterba@suse.com>

I can add it to the btrfs queue now, unless you need the patch for the
rest of the series.
