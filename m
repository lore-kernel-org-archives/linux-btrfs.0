Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E236C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 12:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D09761A11
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 12:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhCYMwZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:52:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhCYMwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Mar 2021 08:52:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6813AD9F;
        Thu, 25 Mar 2021 12:52:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2AFADA732; Thu, 25 Mar 2021 13:49:54 +0100 (CET)
Date:   Thu, 25 Mar 2021 13:49:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH] btrfs: fixed rudimentary typos
Message-ID: <20210325124954.GL7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
References: <20210325042113.12484-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325042113.12484-1-unixbhaskar@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 25, 2021 at 09:51:13AM +0530, Bhaskar Chowdhury wrote:
> 
> s/contaning/containing
> s/clearning/clearing/

Have hou scanned the whole subdirectory for typos? We do typo fixing
about once a year in one big patch and won't fix them one by one.
