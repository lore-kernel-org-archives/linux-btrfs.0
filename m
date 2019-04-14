Return-Path: <SRS0=bDdw=SQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D81C10F11
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Apr 2019 02:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9B02147A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Apr 2019 02:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEC/4nUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfDNCrw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Apr 2019 22:47:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44628 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfDNCrw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Apr 2019 22:47:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id g12so6898683pll.11;
        Sat, 13 Apr 2019 19:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=WFbYH0190ZSKj0CHCf5ojwT34nHPiEfcQa1l/zaKgnM=;
        b=LEC/4nUXMeDGNZNMwQ8c0qmnoQ45k5f9DqcH7NuzkX9GuofoJIwzNowjH6NcIdl9Ij
         MVpqTdSVh58ZFXSw5UOr9M+Q83ZwDxjdtp4C5HpJg1/SOYTzYPAlKrp/R5cGX8x2mx5V
         raO+SMY6E88RZh7yHAlzv7JDBrUlgwICKaJB6lVPS9nkzuiPsN8LiRRcQoJkT+2xowwZ
         hm2Sx6xVq/a6BhOqjypmfvsGoa7+fe2Er4NEIySA8avHz+VgEgFKRxMkp8+HrpmT89YA
         3j/x3VLEuRVVl8Xabkry9A3en0dGtnUk0HPDBnOkxZkKVBGziAhmB/Mwx1s8NoTslMFT
         xmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WFbYH0190ZSKj0CHCf5ojwT34nHPiEfcQa1l/zaKgnM=;
        b=qUZWBveOtaWB+kZ5o6xJrZ01YS7BeYxeK6AqEP5n8x0FxNHI7rTB9vRJHf80sxu8qX
         8oBn+jHufgJiBkMjZq7LY8InBYkzkHcaYHdpQ8efg/+HcXh5nU79KqEubzAhmheSMKae
         LIqW482Ivyny3MFuYLY/9TJIfpn9Ysb4q3ijV4hseAV+6qNRa3naIw9v2aGxB3TXKUtI
         enCuD85Dx/+txHkXwcklCRvgOq1CmblFMGoI2vGWjuXOpox/cuA8UZMRf2Rxua0WUxGl
         euk0BQP9B9Qq01J6jAKqhmVpNL55onXeam7E+8i4+BunaOmqTFIw8dyXAepkVLp6FJ9U
         CveQ==
X-Gm-Message-State: APjAAAXvExb4ryu4fOE/5mxG2vCwcCbJkyXF2DplIO35/9UZe1RckhS7
        wXjs7P+V8lCaEw1AzCGvLsoi/7yIuGo=
X-Google-Smtp-Source: APXvYqwQKzq3piUaZM0CludHFzvRn45nUbu4tjsYOJCir65n4NWCbQox4m2SVgMhzBfQwcbelIjIpA==
X-Received: by 2002:a17:902:d83:: with SMTP id 3mr43131808plv.125.1555210071566;
        Sat, 13 Apr 2019 19:47:51 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id k14sm102080809pfb.125.2019.04.13.19.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 19:47:50 -0700 (PDT)
Date:   Sun, 14 Apr 2019 10:47:45 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs/048: amend property validation cases
Message-ID: <20190414024745.GL2824@desktop>
References: <20190403165419.12666-1-anand.jain@oracle.com>
 <20190403170437.14448-1-anand.jain@oracle.com>
 <7de2d0fd-e777-2bec-5731-15ba2f2af4f2@suse.com>
 <20190406120207.GG2824@desktop>
 <20062818-d303-047c-358f-52ac9dad50de@oracle.com>
 <d552fff5-b43d-6dff-dbb2-3d236041df41@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d552fff5-b43d-6dff-dbb2-3d236041df41@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Apr 07, 2019 at 03:45:36PM +0300, Nikolay Borisov wrote:
> 
> 
> On 7.04.19 г. 14:54 ч., Anand Jain wrote:
> > On 6/4/19 8:02 pm, Eryu Guan wrote:
> >> On Fri, Apr 05, 2019 at 04:21:10PM +0300, Nikolay Borisov wrote:
> >>>
> >>>
> >>> On 3.04.19 г. 20:04 ч., Anand Jain wrote:
> >>>> Add more property validation cases which are fixed by the patches [1]
> >>>>   [1]
> >>>>    btrfs: fix vanished compression property after failed set
> >>>>    btrfs: fix zstd compression parameter
> >>>>
> >>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >>>
> >>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> >>
> >> Thanks for the test and the review!
> >>
> >> But this looks like a targeted regression test that may fail an existing
> >> test. It's better to write a new test for this.
> > 
> > Regression is only when fstests is upgraded. This
> > test case mentions the prerequisite kernel patches [1].
> > So that should suffice the concern?
> 
> I agree with Anand here, this is an extension to an existing test, which
> covers specific feature. IMO it's not good to always introduce new tests
> because every invocation of a test comes with an overhead of spawning
> processes and whatnot. THis is not a problem for 10 tests, but currently
> for btrfs we execute around 600 tests each one "wasting" some cycles to
> spawn bash processes to execute the actual test.

Fair enough. We're having more tests now, and we do consider "merging"
some tests into one case.

Thanks,
Eryu
