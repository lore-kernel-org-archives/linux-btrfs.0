Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_RED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A40C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 16:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A5CE206DC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 16:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgFKQKe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 12:10:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:39906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgFKQKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 12:10:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10490ACBD;
        Thu, 11 Jun 2020 16:10:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 028C1DA82A; Thu, 11 Jun 2020 18:10:22 +0200 (CEST)
Date:   Thu, 11 Jun 2020 18:10:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: Re: [PATCH v2] btrfs: Remove unnecessary failure messages during
 memory allocation
Message-ID: <20200611161022.GR27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Yi Wang <wang.yi59@zte.com.cn>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
References: <1591836036-26253-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591836036-26253-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 11, 2020 at 08:40:36AM +0800, Yi Wang wrote:
> From: Liao Pingfang <liao.pingfang@zte.com.cn>
> 
> As there is a dump_stack() done on memory allocation
> failures, these messages might as well be deleted instead.
> 
> Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
> ---
> Changes in v2: Remove these error messages instead of changing them.

Thanks. I found two more messages to remove and also removed { } when
there was only one statement left.
