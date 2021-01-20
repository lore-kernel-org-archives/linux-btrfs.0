Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6208BC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 14:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1476B2336D
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 14:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbhATOwD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 09:52:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:45794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390539AbhATOOY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jan 2021 09:14:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 630ABAB7F;
        Wed, 20 Jan 2021 13:55:04 +0000 (UTC)
Date:   Wed, 20 Jan 2021 13:54:57 +0000
From:   Michal Rostecki <mrostecki@suse.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, josef@toxicpanda.com
Subject: Re: [PATCH v3 1/4] btrfs: add read_policy latency
Message-ID: <20210120135457.GA6831@wotan.suse.de>
References: <cover.1610324448.git.anand.jain@oracle.com>
 <64bb4905dc4b77e9fa22d8ba2635a36d15a33469.1610324448.git.anand.jain@oracle.com>
 <20210120102742.GA4584@wotan.suse.de>
 <bc5665c0-f066-39af-48e2-dbc063b260ed@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc5665c0-f066-39af-48e2-dbc063b260ed@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 20, 2021 at 08:30:56PM +0800, Anand Jain wrote:
>  I ran fio tests again, now with dstat in an another window. I don't
>  notice any such stalls, the read numbers went continuous until fio
>  finished. Could you please check with the below fio command, also
>  could you please share your fio command options.

That's the fio config I used:

https://gitlab.com/vadorovsky/playground/-/blob/master/fio/btrfs-raid1-seqread.fio

The main differences seem to be:
- the number of jobs (I used the number of CPU threads)
- direct vs buffered I/O

> 
> fio \
> --filename=/btrfs/largefile \
> --directory=/btrfs \
> --filesize=50G \
> --size=50G \
> --bs=64k \
> --ioengine=libaio \
> --rw=read \
> --direct=1 \
> --numjobs=1 \
> --group_reporting \
> --thread \
> --name iops-test-job
> 
>  It is system specific?

With this command, dstat output looks good:

https://paste.opensuse.org/view/simple/93159623

So I think it might be specific to whether we test direct of buffered
I/O. Or to the number of jobs (single vs multiple jobs). Since the most
of I/O on production environments is usually buffered, I think we should
test with direct=0 too.

Cheers,
Michal
