Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4768C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF68206BF
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jCE7C+VO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfDYOOC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:14:02 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36664 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfDYOOB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:14:01 -0400
Received: by mail-yb1-f193.google.com with SMTP id e76so53551ybc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 07:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=oBS41CwsDYA7jKxuAOEz84BKw7EqeF2Uy1/nHXGT0Hc=;
        b=jCE7C+VOewzuM7AnkAVFqpts4X0xwCVL4JoFwoFTt9uJvuogqFxGz2HaEHEU8QLBxp
         PbXCLPSV/7gtP1drK/+0ERhfx8U1woXcw4soPiXaSHO6Olye9qLg7scm05fL59tKppZ4
         X/HQkAzWyaGwhoSOg1B4qf0qFd0oUfj51g++NtKkZVQC559BgDKz897sIGI/InhL9rkA
         RTJd+Q/5sY2Dy0IRjmLK0UkQkjHsWm8LU2rSqD/bb3zJfTOXZLFoxvZAM9KbkPjbR/nB
         TMDgf9lRhuVGRc6I4jQYeqh/t8xa9Bfb/LXfFuseg5EZJqeYjWCQBONCNmCijVhCIzPu
         vOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=oBS41CwsDYA7jKxuAOEz84BKw7EqeF2Uy1/nHXGT0Hc=;
        b=FH80A1W2GEKA+OpDE038BbxGxc2kT6F8zmrhlBUwyD871jPF9DCmX68Aq2yOJusXx1
         qjNELG4JbMYcvDgMSn0nR0T+dXOS6ZbrBdE6lrCLZLm3dHPxRaeDdghvBzKG/gjAE/rC
         zo4pwb3AkbKMyoiYwR9EBNViN6f7EutQbvHGQAfjjRaGBqHrfQ9t82G/JMchss6KRuol
         VPtubiGJ+mSGbPEViCJ/9GpkDBvys8+7BHEgkxDzYSYFNivbtlHutes1zTATK1kWnZDO
         0OqEC0hYfdgNZUqBVUwWqaWtQ3Ks02ZkvMPoQpgSzab6wYmqFZijyHDKoQ7CLlWjEoJ/
         Nj5w==
X-Gm-Message-State: APjAAAU5mevrq0W0N/xoBEaSmhWJVMuRx9xAvgwH69x17p9Hidf0H1Nu
        QvpPWHDF7KZFn4kY6Py4BoIWZA==
X-Google-Smtp-Source: APXvYqzcoKtkxRVTnT4aofx6sa14rJzYyt6gizQOJO3K0qa0W0mGwbG7PicgzqPZWYEyUvFzAzd7yw==
X-Received: by 2002:a25:2fc8:: with SMTP id v191mr7188291ybv.17.1556201640813;
        Thu, 25 Apr 2019 07:14:00 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::46ed])
        by smtp.gmail.com with ESMTPSA id j8sm7730782ywa.72.2019.04.25.07.13.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 07:14:00 -0700 (PDT)
Date:   Thu, 25 Apr 2019 10:13:58 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, dsterba@suse.cz,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fallocate does not prevent ENOSPC on write
Message-ID: <20190425141357.yajfqg4pfuz5y63b@macbook-pro-91.dhcp.thefacebook.com>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 10:11:41PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/25 下午10:09, Josef Bacik wrote:
> > On Thu, Apr 25, 2019 at 09:50:25PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/4/25 下午9:25, Josef Bacik wrote:
> >> [snip]
> >>>>>
> >>>>> What if the commit is reverted, if the problem is otherwise hard to fix?
> >>>>> This seems to break the semantics of fallocate so the performance should
> >>>>> not the main concern here.
> >>>>
> >>>
> >>> Are we sure the ENOSPC is coming from the data reservation?  That change makes
> >>> us fall back on the old behavior, which means we should still succeed at making
> >>> the data reservation.
> >>>
> >>> However it fallocate() _does not_ guarantee you won't fail the metadata
> >>> reservation, I suspect that may be what you are running into.
> >>
> >> For this script, we only needs 4 file extents at most.
> >> Even the initial 8M metadata should be pretty enough, thus I don't think
> >> it's metadata causing the problem.
> >> ---
> >> #!/bin/bash
> >>
> >> dev=/dev/test/test
> >> mnt=/mnt/btrfs
> >>
> >> mkfs.btrfs -f $dev -b 512M
> >>
> >> mount $dev $mnt
> >>
> >> fallocate -l 384M $mnt/file1
> >> echo "fallocate success"
> >> sync
> >> dd if=/dev/zero bs=512K  oflag=direct conv=notrunc count=768 of=$mnt/file2
> >>
> > 
> > Wellll we don't do the nocow check _at all_ for O_DIRECT, so mystery solved
> > there.
> 
> Oh, wrong flag, remove that oflag and we still get the same problem.
> 
> fallocate success
> dd: error writing '/mnt/btrfs/file2': No space left on device
> 95+0 records in
> 94+0 records out
> 49283072 bytes (49 MB, 47 MiB) copied, 0.0807034 s, 611 MB/s
> 

Hmph, then I'm not sure, and I've already exceeded my allowed btrfs/things I
enjoy time for this month.  If we really are getting enospc from the data
reservation then it must mean that the nocow check is failing when it shouldn't.
It shouldn't be hard for you to narrow down what's going wrong.  Thanks,

Josef
