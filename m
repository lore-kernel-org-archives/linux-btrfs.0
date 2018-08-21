Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbeHUXAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 19:00:08 -0400
Subject: Re: [PATCH 0/2] btrfs-progs: task: add prefn() to task_info and
 simplify task_start()
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
References: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ddba11ae-495a-58e1-59a8-c9ffc7cf868d@suse.com>
Date: Tue, 21 Aug 2018 22:38:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.08.2018 21:23, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> This patchset is a prepare work for further process of check.
> 
> patch[1] adds prefn() to task_info and call it before pthread_create().
> 
> patch[2] moves time and count initializations into the new init_ctx(),
> assign it to prefun(). Remove arguments start_time and item_count.
> 

The patches look good albeit being isolated it's hard to see their
merit. I'd advise to submit them alongside whatever larger refactoring
you have in mind.

> 
> Su Yue (2):
>   btrfs-progs: task: add prefn() into struct task_info
>   btrfs-progs: task: add init_ctx and clean up arguments of task_start()
> 
>  check/main.c   | 27 +++++++++++++++++++--------
>  convert/main.c |  6 +++---
>  task-utils.c   | 17 +++++++++--------
>  task-utils.h   |  5 +++--
>  4 files changed, 34 insertions(+), 21 deletions(-)
> 
