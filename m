Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35342 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbbJNBSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 21:18:00 -0400
Received: by padcn9 with SMTP id cn9so6112168pad.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 18:18:00 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: compress: put variables defined per compress type in struct to make cache friendly
In-reply-to: <20151013162834.GM27761@twin.jikos.cz>
Date: Wed, 14 Oct 2015 10:17:53 +0900
Message-ID: <87bnc2w8n2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David Sterba writes:

>
>> +static struct {
>> +	struct list_head idle_workspace;
>> +	spinlock_t workspace_lock;
>> +	int num_workspace;
>> +	atomic_t alloc_workspace;
>> +	wait_queue_head_t workspace_wait;
>> +} comp[BTRFS_COMPRESS_TYPES];
>
> The name became too generic, please rename it to btrfs_comp_ws.
> btrfs_comp_workspaces would be too long. I won't mind trimming the
> members to 'ws' instead of 'workspace' so this does not result in too
> wild code formatting. The use of the workspaces is localized only to the
> compression code so it will not be confusing.

Thanks for feedback.
I will prepare v2 patch applying your comment.
