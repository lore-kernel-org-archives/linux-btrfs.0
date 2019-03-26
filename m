Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8B6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB10C2070D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfCZPJm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:09:42 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34580 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfCZPJl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 11:09:41 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id D9C4627DC7D; Tue, 26 Mar 2019 11:09:38 -0400 (EDT)
Date:   Tue, 26 Mar 2019 11:09:37 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: WARNING at fs/btrfs/delayed-ref.c:296
 btrfs_merge_delayed_refs+0x3dc/0x410 (new on 5.0.4, not in 5.0.3)
Message-ID: <20190326150936.GI16651@hungrycats.org>
References: <20190326025028.GG16651@hungrycats.org>
 <20190326043005.GH16651@hungrycats.org>
 <00ced6df-c0c6-c762-0119-76218ab4ca0b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <00ced6df-c0c6-c762-0119-76218ab4ca0b@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 10:42:31AM +0200, Nikolay Borisov wrote:
> 
> 
> On 26.03.19 г. 6:30 ч., Zygo Blaxell wrote:
> > On Mon, Mar 25, 2019 at 10:50:28PM -0400, Zygo Blaxell wrote:
> >> Running balance, rsync, and dedupe, I get kernel warnings every few
> >> minutes on 5.0.4.  No warnings on 5.0.3 under similar conditions.
> >>
> >> Mount options are:  flushoncommit,space_cache=v2,compress=zstd.
> >>
> >> There are two different stacks on the warnings.  This one comes from
> >> btrfs balance:
> > 
> > [snip]
> > 
> > Possibly unrelated, but I'm also repeatably getting this in 5.0.4 and
> > not 5.0.3, after about 5 hours of uptime.  Different processes, same
> > kernel stack:
> > 
> > 	[Mon Mar 25 23:35:17 2019] kworker/u8:4: page allocation failure: order:0, mode:0x404000(GFP_NOWAIT|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
> > 	[Mon Mar 25 23:35:17 2019] CPU: 2 PID: 29518 Comm: kworker/u8:4 Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1
> 
> What commits does this kernel include because it doesn't seem to be a
> pristine upstream 5.0.4 ? Also what you are seeing below is definitely a
> bug in MM. The question is whether it's due to your doing faulty
> backports in the kernel or it's due to something that got automatically
> backported to 5.0.4

That was the first thing I thought of, so I reverted to vanilla 5.0.4,
repeated the test, and obtained the same result.

You may have a point about non-btrfs patches in 5.0.4, though.
I previously tested 5.0.3 with most of the 5.0.4 fs/btrfs commits
already included by cherry-pick:

	1098803b8cb7 Btrfs: fix deadlock between clone/dedupe and rename
	3486142a68e3 Btrfs: fix corruption reading shared and compressed extents after hole punching
	fb9c36acfab1 btrfs: scrub: fix circular locking dependency warning
	9d7b327affb8 Btrfs: setup a nofs context for memory allocation at __btrfs_set_acl
	80dcd07c27df Btrfs: setup a nofs context for memory allocation at btrfs_create_tree()

The commits that are in 5.0.4 but not in my last 5.0.3 test run are:

	ebbb48419e8a btrfs: init csum_list before possible free
	88e610ae4c3a btrfs: ensure that a DUP or RAID1 block group has exactly two stripes
	9c58f2ada4fa btrfs: drop the lock on error in btrfs_dev_replace_cancel

and I don't see how those commits could lead to the observed changes
in behavior.  I didn't include them for 5.0.3 because my test scenario
doesn't execute the code they touch.  So the problem might be outside
of btrfs completely.
