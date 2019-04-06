Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6706C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8987D218AC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDFARF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 20:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfDFARE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 20:17:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1479E3082231;
        Sat,  6 Apr 2019 00:17:04 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74FA919C56;
        Sat,  6 Apr 2019 00:16:58 +0000 (UTC)
Date:   Sat, 6 Apr 2019 08:16:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible bio merging breakage in mp bio rework
Message-ID: <20190406001653.GA4805@ming.t460p>
References: <59c19acf-999f-1911-b0b8-1a5cec8116c5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59c19acf-999f-1911-b0b8-1a5cec8116c5@suse.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 06 Apr 2019 00:17:04 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nikolay,

On Fri, Apr 05, 2019 at 07:04:18PM +0300, Nikolay Borisov wrote:
> Hello Ming, 
> 
> Following the mp biovec rework what is the maximum 
> data that a bio could contain? Should it be PAGE_SIZE * bio_vec 

There isn't any maximum data limit on the bio submitted from fs,
and block layer will make the final bio sent to driver correct
by applying all kinds of queue limit, such as max segment size,
max segment number, max sectors, ...

> or something else? Currently I can see bios as large as 127 megs 
> on sequential workloads, I got prompted to this since btrfs has a 
> memory allocation that is dependent on the data in the bio and this 
> particular memory allocation started failing with order 6 allocs. 

Could you share us the code? I don't see why order 6 allocs is a must.

> Further debugging showed that with the following xfs_io command line: 
> 
> 
> xfs_io -f -c "pwrite -S 0x61 -b 4m 0 10g" /media/scratch/file1
> 
> I can easily see very large bios: 
> 
> [  188.366540] kworker/-7       3.... 34847519us : btrfs_submit_bio_hook: bio: ffff8dffe9940bb0 bi_iter.bi_size = 134184960 bi_vcn: 28 bi_vcnt_max: 256
> [  188.367129] kworker/-658     2.... 34946536us : btrfs_submit_bio_hook: bio: ffff8dffe9940370 bi_iter.bi_size = 134246400 bi_vcn: 28 bi_vcnt_max: 256
> [  188.367714] kworker/-7       3.... 35107967us : btrfs_submit_bio_hook: bio: ffff8dffe9940bb0 bi_iter.bi_size = 134184960 bi_vcn: 30 bi_vcnt_max: 256
> [  188.368319] kworker/-658     2.... 35229894us : btrfs_submit_bio_hook: bio: ffff8dffe9940370 bi_iter.bi_size = 134246400 bi_vcn: 32 bi_vcnt_max: 256
> [  188.368909] kworker/-7       3.... 35374809us : btrfs_submit_bio_hook: bio: ffff8dffe9940bb0 bi_iter.bi_size = 134184960 bi_vcn: 25 bi_vcnt_max: 256
> [  188.369498] kworker/-658     2.... 35516194us : btrfs_submit_bio_hook: bio: ffff8dffe9940370 bi_iter.bi_size = 134246400 bi_vcn: 31 bi_vcnt_max: 256
> [  188.370086] kworker/-7       3.... 35663669us : btrfs_submit_bio_hook: bio: ffff8dffe9940bb0 bi_iter.bi_size = 134184960 bi_vcn: 32 bi_vcnt_max: 256
> [  188.370696] kworker/-658     2.... 35791006us : btrfs_submit_bio_hook: bio: ffff8dffe9940370 bi_iter.bi_size = 100655104 bi_vcn: 24 bi_vcnt_max: 256
> [  188.371335] kworker/-658     2.... 35816114us : btrfs_submit_bio_hook: bio: ffff8dffe99434f0 bi_iter.bi_size = 33591296 bi_vcn: 5 bi_vcnt_max: 256
> 
> 
> So that's 127 megs in a single bio? This stems from the new merging logic. 
> 07173c3ec276 ("block: enable multipage bvecs") made it so that physically 
> contiguous pages added to the bio would just modify bi_iter.bi_size and the 
> initial page's bio_vec's bv_len. There's no longer the 
> page == bv->bv_page portion of the check. 

bio_add_page() tries best to put physically contiguous pages into one bvec, and
I don't see anything is wrong in the log.

Could you show us what the real problem is?

Thanks,
Ming
