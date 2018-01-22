Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbeAVIqj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 03:46:39 -0500
Subject: Re: [PATCH] btrfs: remove spurious WARN_ON(ref->count) in
 find_parent_nodes
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, enadolski@suse.com
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
 <20180122033452.GA532@fnst.localdomain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9151459e-8db2-bdd1-a21e-23d730cb52a4@suse.com>
Date: Mon, 22 Jan 2018 10:46:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180122033452.GA532@fnst.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.01.2018 05:34, Lu Fengqi wrote:
> According to my bisect result, The frequency of the warning occurrence
> increased to the detectable degree after this patch

That sentence implies that even before Ed's patch it was possible to
trigger those warnings, is that true? Personally I've never seen such
warnings while executing btrfs/004. How do you configure the filesystem
for the test runs?

> 86d5f9944252 ("btrfs: convert prelimary reference tracking to use rbtrees")
> is committed. I understand that this does not mean that this patch caused
> the problem, but maybe Edmund can give us some help, so I added him to the
> recipient.
