Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49674 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762269AbcINOtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 10:49:16 -0400
Subject: Re: [PATCH 0/3] block: Improve bio_set_op_attrs() robustness
To: Bart Van Assche <bart.vanassche@sandisk.com>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
CC: Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>,
        "device-mapper development" <dm-devel@redhat.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <7b465fd4-fd31-1561-239d-d0215b6557ea@fb.com>
Date: Wed, 14 Sep 2016 08:48:50 -0600
MIME-Version: 1.0
In-Reply-To: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2016 02:42 AM, Bart Van Assche wrote:
> Hi Jens,
>
> bio_set_op_attrs() does not yet check whether the "op_flags" field
> overflows into the "op" field. Since adding support for SMR requires to
> introduce more REQ_* flags I think it is important to have such a check.
> Hence this patch series. Please consider these patches for inclusion in
> the upstream Linux kernel.

Thanks Bart, I like this series. Applied for 4.9.

-- 
Jens Axboe

