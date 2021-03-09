Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DECC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 12:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A79A65268
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 12:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCIMZR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 07:25:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:51628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhCIMYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Mar 2021 07:24:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 992C6AC8C;
        Tue,  9 Mar 2021 12:24:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4E530DA81B; Tue,  9 Mar 2021 13:22:48 +0100 (CET)
Date:   Tue, 9 Mar 2021 13:22:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: turn btrfs_destroy_delayed_refs() into void
 function
Message-ID: <20210309122248.GG7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Yang Li <yang.lee@linux.alibaba.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1615282374-29598-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615282374-29598-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 09, 2021 at 05:32:54PM +0800, Yang Li wrote:
> This function always return '0' and no callers use the return value.
> So make it a void function.
> 
> This eliminates the following coccicheck warning:
> ./fs/btrfs/disk-io.c:4522:5-8: Unneeded variable: "ret". Return "0" on
> line 4530
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>

Can you please tell your robot to ignore this warning, I'm getting tired
to explain the same thing again,

https://lore.kernel.org/linux-btrfs/20210302120708.GH7604@suse.cz/

this is like 5th attempt to blindly fix a tool warning without
understanding the code.
