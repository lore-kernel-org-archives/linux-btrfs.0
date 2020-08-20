Return-Path: <SRS0=L84K=B6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447CAC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 12:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F17207BB
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 12:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgHTMwm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 08:52:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:39800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbgHTJnS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 41B32AE96;
        Thu, 20 Aug 2020 09:43:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74235DA87C; Thu, 20 Aug 2020 11:42:11 +0200 (CEST)
Date:   Thu, 20 Aug 2020 11:42:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Daniel Martinez <danielsmartinez@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BUG: kernel NULL pointer dereference when using zstd
Message-ID: <20200820094211.GW2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Daniel Martinez <danielsmartinez@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAMmfObZhCNGDW6Z4jGHNA+ZCVP=tWvt=DLm1isuwRS4NEebp4Q@mail.gmail.com>
 <4988ccc8-8c18-ecde-c6d4-bc2aa0360482@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4988ccc8-8c18-ecde-c6d4-bc2aa0360482@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:31:15AM +0800, Qu Wenruo wrote:
> 
> 
> On 2020/8/20 上午7:14, Daniel Martinez wrote:
> > Hello,
> > 
> > I have encountered a bug when using zstd compression (I assume that's
> > what caused it, but I could be wrong) on the Debian kernel 5.7.10-1.
> 
> It's not zstd I guess, but a generic compression bug.
> 
> It's fixed by the upstream commit 1e6e238c3002 ("btrfs: inode: fix NULL
> pointer dereference if inode doesn't need compression").
> 
> It's not yet merged into v5.7.y stable branch, I guess I need to
> backport it manually then.

The commit is in 5.4, 5.7 and 5.8 queue, so the next stable release will
have it.
