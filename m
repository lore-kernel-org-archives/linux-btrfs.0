Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbeGXLr4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 07:47:56 -0400
Date: Tue, 24 Jul 2018 12:41:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] fs_info cleanups for volume.c
Message-ID: <20180724104157.GT26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
 <20180723132501.GL26141@twin.jikos.cz>
 <20180724082804.GS26141@twin.jikos.cz>
 <20180724085856.GF575@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180724085856.GF575@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2018 at 04:59:00PM +0800, Lu Fengqi wrote:
> After I applied this patchset, my test also encountered this crash.
> However, the result of git bisect shows the cause may be the
> "[PATCH 2/2] btrfs: fix missing superblock update in the device delete commit transaction".
> Moreover, I have reported this to Anand Jain. I will send him the updated
> log(kasan enabled), and tell him why he can't reproduce before. Please
> see the thread I will cc you.

Thanks for bisecting it, I'll remove the patch until it's resolved and
re-add Nikolai's patches.
