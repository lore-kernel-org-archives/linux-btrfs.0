Return-Path: <SRS0=sbT/=2Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E42C32767
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 15:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 443102468D
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 15:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgACPMB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 10:12:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:42724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgACPMB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Jan 2020 10:12:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73F20AF2B;
        Fri,  3 Jan 2020 15:11:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2444EDA795; Fri,  3 Jan 2020 16:11:51 +0100 (CET)
Date:   Fri, 3 Jan 2020 16:11:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Chris Murphy <chris@colorremedies.com>
Cc:     David Sterba <dsterba@suse.cz>, Josef Bacik <josef@toxicpanda.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: 5.5.0-0.rc1 hang, could be zstd compression related
Message-ID: <20200103151150.GY3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chris Murphy <chris@colorremedies.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <CAJCQCtS_7vjBnqeDsedBQJYuE_ap+Xo6D=MXY=rOxf66oJZkrA@mail.gmail.com>
 <4eca86cf-65c3-5aba-d0fd-466d779614e6@toxicpanda.com>
 <20191211155553.GP3929@twin.jikos.cz>
 <20191211155931.GQ3929@twin.jikos.cz>
 <CAJCQCtTH65e=nOxsmy-QYPqmsz9d2YciPqxUGUpdqHnXvXLY4A@mail.gmail.com>
 <CAJCQCtTC_nJmBZmv2Vo0H-C9=ra=FuGwtYbPg41bF8VL5c9kPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtTC_nJmBZmv2Vo0H-C9=ra=FuGwtYbPg41bF8VL5c9kPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 03, 2020 at 01:26:08AM -0700, Chris Murphy wrote:
> BTW, I hit this with lzo too, so it's not zstd specific.

That's correct and the fix is going to appear in the next -rc.
