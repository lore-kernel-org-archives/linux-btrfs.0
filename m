Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53459 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755898AbcINIxz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 04:53:55 -0400
Date: Wed, 14 Sep 2016 10:53:53 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH 2/3] block, dm-crypt, btrfs: Introduce bio_flags()
Message-ID: <20160914085353.xypauilwqkuy43bu@linux-x5ow.site>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
 <144083a3-2d0a-00ff-add2-a2f6f3690528@sandisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <144083a3-2d0a-00ff-add2-a2f6f3690528@sandisk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 10:45:36AM +0200, Bart Van Assche wrote:
> Introduce the bio_flags() macro. Ensure that the second argument of
> bio_set_op_attrs() only contains flags and no operation. This patch
> does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Chris Mason <clm@fb.com> (maintainer:BTRFS FILE SYSTEM)
> Cc: Josef Bacik <jbacik@fb.com> (maintainer:BTRFS FILE SYSTEM)
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@hgst.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
