Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51785 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbbFIOLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 10:11:08 -0400
Message-ID: <5576F3F0.6050900@fb.com>
Date: Tue, 9 Jun 2015 10:10:56 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
CC: <adam900710@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com>
In-Reply-To: <557506BC.701@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2015 11:06 PM, Qu Wenruo wrote:
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
> But only need to record dirty delayed-ref, and account quota at
> transaction time.
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
> The only problem left is, we need a new mechanism to account subvolume
> deletion. But this is the long-existing problem, I'd prefer to address
> it in next merge windows if we have a pretty method to solve it.
>
> Or maybe a small patch to mark qgroup inconsistent when delete subvolume
> with level higher than 0.
>
> 2. write-rm-loop fixes from Zhao Lei.
> Other patches from Zhao Lei and Forrest Liu have already been merged
> into mainline, but this is the one still unmerged.
>
> This patch fixes the last super rare problem we found in write-rm-loop
> case.
> And the patch will only modify the minor routine, so it won't affect the
> normal routine.
>

btrfs: delayed-ref: Use list to replace the ref_root in ref_head.

The merge is there for when we can't merge refs because somebody did a 
backref search and jacked up the sequence number, this will completely 
break the backref searching code since now you are allowing merge's of 
delayed refs that have different sequence numbers.  Thanks,

Josef
