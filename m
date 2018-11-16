Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F23C43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19BEB208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19BEB208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389465AbeKPTxa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:53:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:42901 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727405AbeKPTxa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 14:53:30 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6105A91790A54;
        Fri, 16 Nov 2018 17:41:54 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Nov
 2018 17:41:50 +0800
Subject: Re: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
To:     Christoph Hellwig <hch@lst.de>
CC:     Omar Sandoval <osandov@osandov.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        <dm-devel@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>,
        <linux-raid@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        <linux-ext4@vger.kernel.org>, Coly Li <colyli@suse.de>,
        <linux-bcache@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>,
        "Bob Peterson" <rpeterso@redhat.com>, <cluster-devel@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com> <20181115202028.GC9348@vader>
 <20181115210510.GA24908@redhat.com> <20181115221847.GD9348@vader>
 <20181116091956.GA17604@lst.de>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <a0105f7a-95b2-3a42-1543-3e8b999edb30@huawei.com>
Date:   Fri, 16 Nov 2018 17:41:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20181116091956.GA17604@lst.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 2018/11/16 17:19, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 02:18:47PM -0800, Omar Sandoval wrote:
>> My only reason to prefer unsigned int is consistency. unsigned int is
>> much more common in the kernel:
>>
>> $ ag --cc -s 'unsigned\s+int' | wc -l
>> 129632
>> $ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
>> 22435
>>
>> checkpatch also warns on plain unsigned.
> 
> Talk about chicken and egg.  unsigned is perfectly valid C, and being
> shorter often helps being more readable.  checkpath is as so often
> wrongly opinionated..
> 

sigh...I personally tend to use "unsigned" instead of "unsigned int" as well,
but checkpatch.pl also suggests erofs to use "unsigned int" :-(

Thanks,
Gao Xiang
