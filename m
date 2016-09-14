Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0089.outbound.protection.outlook.com ([104.47.34.89]:51616
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755494AbcINI5P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 04:57:15 -0400
To: Jens Axboe <axboe@fb.com>
CC: Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>,
        "device-mapper development" <dm-devel@redhat.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/3] block: Improve bio_set_op_attrs() robustness
Message-ID: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Date: Wed, 14 Sep 2016 10:42:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jens,

bio_set_op_attrs() does not yet check whether the "op_flags" field 
overflows into the "op" field. Since adding support for SMR requires to 
introduce more REQ_* flags I think it is important to have such a check. 
Hence this patch series. Please consider these patches for inclusion in 
the upstream Linux kernel.

Thanks,

Bart.
