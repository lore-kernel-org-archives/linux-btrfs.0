Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3DPJok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:44:40 -0400
Message-ID: <516D1E8B.6050000@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 17:48:59 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Btrfs: rescan for qgroups
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net> <516D1947.2000306@cn.fujitsu.com> <516D1C49.6010406@jan-o-sch.net>
In-Reply-To: <516D1C49.6010406@jan-o-sch.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt Ð´µÀ:

..[snip]..
> 
> I don't see where I'm calling ulist_free(roots) in the error path. One of us is
> missing something :-)


Yeah, you are right. i read a more '}'.. ^_^

Thanks,
Wang

> 
>>> +		spin_lock(&fs_info->qgroup_lock);
>>> +		seq = fs_info->qgroup_seq;
>>> +		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
>>> +
>>> +		ulist_reinit(tmp);
>>> +		ULIST_ITER_INIT(&uiter);
>>> +		while ((unode = ulist_next(roots, &uiter))) {
>>> +			struct btrfs_qgroup *qg;
>>> +
>>> +			qg = find_qgroup_rb(fs_info, unode->val);
>>> +			if (!qg)
>>> +				continue;
>>> +
>>> +			ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
>>
>> For this patch, you forget to add the check about ulist_add(), ulist_add() may
>> return -ENOMEM. In fact, i have sent the patch to fix this problem in qgroup.c before.
>> So you don't need to change patch1, but you dose need to add the check in the patch2.
> 
> Thanks for noticing, I'll send a fix in a few days to leave room for more comments.
> 
> -Jan
> 
>>> +		}

[snip]

