Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88BEC433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 22:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5FB22D04
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 22:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbhAKWR0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:17:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:38092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbhAKWR0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jan 2021 17:17:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B87B1AB3E;
        Mon, 11 Jan 2021 22:16:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A460ADA701; Mon, 11 Jan 2021 23:14:52 +0100 (CET)
Date:   Mon, 11 Jan 2021 23:14:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [PATCH 05/13] btrfs: do not WARN_ON() if we can't find the reloc
 root
Message-ID: <20210111221452.GK6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <cover.1608135557.git.josef@toxicpanda.com>
 <d11a0c1770a96bdf382cc3f41eb71fb790650aa5.1608135557.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11a0c1770a96bdf382cc3f41eb71fb790650aa5.1608135557.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 16, 2020 at 11:22:09AM -0500, Josef Bacik wrote:
> Any number of things could have gone wrong, like ENOMEM or EIO, so don't
> WARN_ON() if we're unable to find the reloc root in the backref code.

Where does the ENOMEM or EIO happen? The return value from
find_reloc_root is just a pointer and besides the rbtree lookup, there's
nothing else.

Removing the warning makes sense, or at least replacing with a warning
if that would bring some value, but otherwise it's handled and can stay
silent.
