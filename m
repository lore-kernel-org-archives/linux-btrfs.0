Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1630FC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 03:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiCWDPZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 23:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiCWDPY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Mar 2022 23:15:24 -0400
Received: from synology.com (mail.synology.com [211.23.38.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8341B6545
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2022 20:13:52 -0700 (PDT)
Subject: Re: [PATCH] btrfs: prevent subvol with swapfile from being deleted
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1648005230; bh=0x5meJScpDrTYk1z5UxgpURmSt0LX4MJhHiOmf8nm/M=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=TuFoZQRHPVqahDRMcnU2V0y84ZCkTBtRw+zU/H7PB33EfJQHWQJB5KXIp4MGh9/eL
         zcxg/SQKL0uZnqK3JK5MM+Ws5WAfuG1GMg7fRhK4OaSRBPXaGD1qT/nElp8p9WKsjy
         YyebGXqXmiREufsC8rvNaYVPSMlNZxC5urGd2ZYE=
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, robbieko@synology.com,
        cccheng@synology.com, seanding@synology.com
References: <20220322102705.1252830-1-kevinhu@synology.com>
 <b1c66869-2920-9055-faa1-a84b05958289@gmx.com>
 <20220322193932.GI12643@twin.jikos.cz>
From:   Kaiwen Hu <kevinhu@synology.com>
Message-ID: <71bc3a52-ae07-3030-49f1-6cc176a0f16e@synology.com>
Date:   Wed, 23 Mar 2022 11:13:50 +0800
MIME-Version: 1.0
In-Reply-To: <20220322193932.GI12643@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 3/23/2022 3:39 AM, David Sterba wrote:
> On Tue, Mar 22, 2022 at 06:47:59PM +0800, Qu Wenruo wrote:
>> This looks a little weird to me.
>>
>> If the root is already dead, it means we should not be able to access
>> any file inside the subvolume.
>>
>> How could we go into btrfs_swap_activate() while the root is already dead?
>>
>> Or is there some special race I missed?
> The deletion has a few steps, eg. the dentry is removed, root is marked
> as dead and different thing locking protection.
>
> I was wondering about file descriptor access to the subvolume and
> calling swapon on that, but swapon/swapoff is a syscall and work with a
> path argument so that can't happen. I haven't checked in what order are
> the dentry removal and dead flag done, it could be theoretically
> possible that there's a short window where the dentry is accessible and
> subvolume already marked.


Thanks for david's help.  Yes, it is possible the subvolume is marked 
for deletion,  but still not remove yet.  So like 
|btrfs_ioctl_send()|doing, I check the dead-root mark before activating 
swapfile to prevent the race condition.


Thanks,

Kaiwen Hu




