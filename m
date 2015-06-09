Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f195.google.com ([209.85.192.195]:36405 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbbFIGEA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 02:04:00 -0400
Received: by pdev10 with SMTP id v10so2060208pde.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2015 23:04:00 -0700 (PDT)
Message-ID: <557681C6.7050608@gmail.com>
Date: Tue, 09 Jun 2015 14:03:50 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
CC: adam900710@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com>
In-Reply-To: <557506BC.701@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

> Hi Chris,
> 
> Please pull the 19 patchset from my branch for_chris_4.2.
> We have tested it in a week.
> 
> Although it is originally based on 4.1-rc5, not the integration branch.
> Quick tests shows no new bugs, although we will rerun the full test,
> I'll send the patchset first for your reviewing:
> 
> https://github.com/adam900710/linux.git for_chris_4.2
> 
> This contains the following patches.
> 
> 1. Qgroup rework (first 18 commits)
> These commits rework the qgroup framework.
> Now, quota won't need to do per-delayed-ref accounting.
> But only need to record dirty delayed-ref, and account quota at transaction time.

Can you share perfomaces results with/without patches with quota enabled.
Especially, if there are thounds of snapshots, how much performaces down or up
with these patches applied.

Regards,
Wang Shilong

> 
> The good thing is, at transaction time, we have no other interruption or
> concurrency, account can be quite accurate and only need to account once
> for every dirty extent.(especially faster for shared extents)
> 
> And clearer codes and logic. Codes changes from 1K to 0.5K, even a lot
> of comments are added.
> 
> With the patchset, btrfs can pass all qgroup test in fstests.
> No longer minus number now.
> 
> The only problem left is, we need a new mechanism to account subvolume deletion. But this is the long-existing problem, I'd prefer to address
> it in next merge windows if we have a pretty method to solve it.
> 
> Or maybe a small patch to mark qgroup inconsistent when delete subvolume with level higher than 0.
> 
> 2. write-rm-loop fixes from Zhao Lei.
> Other patches from Zhao Lei and Forrest Liu have already been merged
> into mainline, but this is the one still unmerged.
> 
> This patch fixes the last super rare problem we found in write-rm-loop
> case.
> And the patch will only modify the minor routine, so it won't affect the normal routine.
> 
> Thanks,
> Qu
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
