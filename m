Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946A2C433B4
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 May 2021 13:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67708611BF
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 May 2021 13:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhEONjK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 15 May 2021 09:39:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:41234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhEONjJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 May 2021 09:39:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 55835B03E;
        Sat, 15 May 2021 13:37:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8869DAEB9; Sat, 15 May 2021 15:35:23 +0200 (CEST)
Date:   Sat, 15 May 2021 15:35:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Sidong Yang <realwakka@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume: destroy associated qgroup when
 delete subvolume
Message-ID: <20210515133523.GC7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Sidong Yang <realwakka@gmail.com>, linux-btrfs@vger.kernel.org
References: <20210515023624.8065-1-realwakka@gmail.com>
 <7702abe4-f150-44c0-8328-f62d68f5a56c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7702abe4-f150-44c0-8328-f62d68f5a56c@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, May 15, 2021 at 10:42:15AM +0800, Qu Wenruo wrote:
> On 2021/5/15 上午10:36, Sidong Yang wrote:
> > This patch adds the options --delete-qgroup and --no-delete-qgroup. When
> > the option is enabled, delete subvolume command destroies associated
> > qgroup together. This patch make it as default option. Even though quota
> > is disabled, it enables quota temporary and restore it after.
> 
> No, this is not a good idea at all.
> 
> First thing first, if quota is disabled, all qgroup info including the
> level 0 qgroups will also be deleted, thus no need to enable in the
> first place.
> 
> Secondly, there is already a patch in the past to delete level 0 qgroups
> in kernel space, which should be a much better solution.

I've filed the issue to do it in the userspace because it gives user
more control whether to do the deletion or not and to also cover all
kernels that won't get the patch (ie. old stable kernels).

Changing the default behaviour is always risky and has a potential to
break user scripts. IMO adding the option to progs and changing the
default there is safer in this case.
