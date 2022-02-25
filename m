Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FE2C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Feb 2022 11:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiBYLvz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 06:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbiBYLvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Feb 2022 06:51:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AAF1CABE0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Feb 2022 03:51:20 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 64805212B9;
        Fri, 25 Feb 2022 11:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645789879;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUVLRXTdO+R4E4dUK+rMdNSiaKMRFz+H/JMseJ8d7LU=;
        b=bETJzGMOx4zE7A6W3ZoWosVdlI/LhICAplNFWB6qOuo2mWnQiEaBCFM8vwnffT1MKi9QNw
        PTLUUo1vuhFC1HKawPQ5KqYHRVgdRGwmY3vmMLOf11Z+Y8u4rv2H5YUatsmIc6fgRVSbBs
        lpciio1Kc/w1tTvuKXoLzxd5VktA8A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645789879;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUVLRXTdO+R4E4dUK+rMdNSiaKMRFz+H/JMseJ8d7LU=;
        b=sgh4lEj2I+PnCoIUYJHmrMWQaifS/M1hRcmEIST7Q6Mv7E7tThj7PZwdnutFiCHSIHRZb2
        LGH7u/x8cPCOkcCg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 5BD5FA3B81;
        Fri, 25 Feb 2022 11:51:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EE4F8DA818; Fri, 25 Feb 2022 12:47:29 +0100 (CET)
Date:   Fri, 25 Feb 2022 12:47:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Seed device is broken, again.
Message-ID: <20220225114729.GE12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <88176dfc-2500-1e9c-bac0-5e293b2c0b5c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88176dfc-2500-1e9c-bac0-5e293b2c0b5c@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 25, 2022 at 06:08:20PM +0800, Qu Wenruo wrote:
> Hi,
> 
> The very basic seed device usage is broken again:
> 
> 	mkfs.btrfs -f $dev1 > /dev/null
> 	btrfstune -S 1 $dev1
> 	mount $dev1 $mnt
> 	btrfs dev add $dev2 $mnt
> 	umount $mnt
> 
> 
> I'm not sure how many guys are really using seed device.
> 
> But I see a lot of weird operations, like calling a definite write 
> operation (device add) on a RO mounted fs.

That's how the seeding device works, in what way would you want to do
the ro->rw change?

> Can we make at least the seed sprouting part into btrfs-progs instead?

How? What do you mean? This is an in kernel operation that is done on a
mounted filesystem, progs can't do that.

> And can seed device even support the upcoming extent-tree-v2?

I should, it operates on the device level.

> Personally speaking I prefer to mark seed device deprecated completely.

If we did that with every feature some developer does not like we'd have
nothing left you know. Seeding is a documented usecase, as long as it
works it's fine to have it available.

> The call trace:
> 
>   assertion failed: sb_write_started(fs_info->sb), in 
> fs/btrfs/volumes.c:3244

Yeah the asserts now appear and we need to fix the write annotations
first. I've moved the patches out of misc-next again, it's now only in
for-next so it does not block testing.

