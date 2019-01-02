Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDFFC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 02:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3232080A
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 02:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfABCut (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jan 2019 21:50:49 -0500
Received: from [195.159.176.226] ([195.159.176.226]:40769 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfABCut (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jan 2019 21:50:49 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1geWaB-0006R6-Ku
        for linux-btrfs@vger.kernel.org; Wed, 02 Jan 2019 03:48:35 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Undelete files
Date:   Wed, 2 Jan 2019 02:48:28 +0000 (UTC)
Message-ID: <pan$dcdef$678b9b0d$9f8492f4$6519613a@cox.net>
References: <20181229225140.08d397fb@ws>
        <CADXXWGw-8uDqeXSdjkwmBfK4-OiN5Wk7q3k2yPvzFiF3uzYmzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Jesse Emeth posted on Sun, 30 Dec 2018 16:58:12 +0800 as excerpted:

> Hi Duncan
> 
> The backup is irrelevant in this case. I have a backup of this
> particular problem.
> I've had BTRFS on my OS system blow up several times.
> There are several snapshots of this within the subvolume.
> However, such snapshots are not helpful unless they are snapshots
> copied elsewhere with restore/rsync etc.

How can backups and snapshots not be helpful in terms of a problem where 
you'd be using undelete?  Undelete implies the filesystem is fine and 
that you're just trying to get a few files that you mistakenly deleted 
back, which in fact was the claim, and both backups and snapshots should 
allow you to do just that, get your deleted files back.

> I had spoken to someone expressing my concerns with BTRFS on IRC.
> He wanted me to present this so that such problems could be rectified.
> I also wanted to learn more about BTRFS to see if my determinations
> about its inadequacies were incorrect.
> 
> Thus I want to follow this through to see if what is actually a very
> very small problem related to just a non essential small Firefox cache
> directory can actually be fixed.
> At present this very very small problem brings down the entire volume
> and all subvolumes with no way to mount any of it rw or easily fix the
> issue.
> That is not sane for such a small issue.

That's not a file undelete issue.  That's an entire filesystem issue.  
Quite a different beast, and not one that I directly addressed in my 
reply (altho the data value vs. backups stuff applies to fat-fingering 
such as mistaken deletes, filesystem problems, hardware problems, and 
natural disasters, all four), because both the title and the content 
suggested a file undelete issue, which /was/ addressed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

