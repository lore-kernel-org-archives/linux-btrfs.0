Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05BEC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 18:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F772077B
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 18:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfCRSqH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 14:46:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:50904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726839AbfCRSqH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 14:46:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AEB38AF0C;
        Mon, 18 Mar 2019 18:46:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29C1DDA829; Mon, 18 Mar 2019 19:47:21 +0100 (CET)
Date:   Mon, 18 Mar 2019 19:47:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: raid56: properly unmap parity page in
 finish_parity_scrub()
Message-ID: <20190318184720.GF3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrea Righi <andrea.righi@canonical.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190313101703.GA9155@xps-13>
 <20190314075628.GA11282@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314075628.GA11282@xps-13>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 08:56:28AM +0100, Andrea Righi wrote:
> Parity page is incorrectly unmapped in finish_parity_scrub(), triggering
> a reference counter bug on i386, i.e.:
> 
>  [ 157.662401] kernel BUG at mm/highmem.c:349!
>  [ 157.666725] invalid opcode: 0000 [#1] SMP PTI
> 
> The reason is that kunmap(p_page) was completely left out, so we never
> did an unmap for the p_page and the loop unmapping the rbio page was
> iterating over the wrong number of stripes: unmapping should be done
> with nr_data instead of rbio->real_stripes.
> 
> Test case to reproduce the bug:
> 
>  - create a raid5 btrfs filesystem:
>    # mkfs.btrfs -m raid5 -d raid5 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> 
>  - mount it:
>    # mount /dev/sdb /mnt
> 
>  - run btrfs scrub in a loop:
>    # while :; do btrfs scrub start -BR /mnt; done
> 
> BugLink: https://bugs.launchpad.net/bugs/1812845
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.
