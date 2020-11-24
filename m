Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB86C2D0E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B14206FB
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390142AbgKXQHC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:07:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:44748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbgKXQHC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Nov 2020 11:07:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0039EAC2D;
        Tue, 24 Nov 2020 16:07:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 45C12DA818; Tue, 24 Nov 2020 17:05:32 +0100 (CET)
Date:   Tue, 24 Nov 2020 17:05:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove noinline attribute from wait_for_commit
Message-ID: <20201124160532.GA6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201124144502.3168362-1-nborisov@suse.com>
 <20201124153950.GA1803@twin.jikos.cz>
 <ed0b6532-e4ee-1bdb-6376-0393c3d976b2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed0b6532-e4ee-1bdb-6376-0393c3d976b2@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 24, 2020 at 05:42:57PM +0200, Nikolay Borisov wrote:
> 
> 
> On 24.11.20 г. 17:39 ч., David Sterba wrote:
> > On Tue, Nov 24, 2020 at 04:45:02PM +0200, Nikolay Borisov wrote:
> >> The function is a plain wrapper that noinline makes no sense.
> > 
> > Or it is a way to let the function name appear in a stack trace, which
> > could be useful for debugging or analyzing system state.
> > 
> 
> Well, this information could generally be derived by having the debug
> info  either in crash or one of the "beautify" scripts. In any case I
> won't insist.

The way it's used is 'cat /proc/*/stack', without the need of debugging
kernels and not in a post-mortem analysis with crash.
