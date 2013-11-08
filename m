Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33477 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3KHA6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:58:12 -0500
Message-ID: <527C3751.3090605@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 08:58:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented
 ordered execution based on kernel workqueue
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com> <20131107180826.GI27784@localhost.localdomain> <20131107180956.GJ27784@localhost.localdomain>
In-Reply-To: <20131107180956.GJ27784@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Nov 2013 13:09:56 -0500, Josef Bacik wrote:
> On Thu, Nov 07, 2013 at 01:08:26PM -0500, Josef Bacik wrote:
>> On Thu, Nov 07, 2013 at 01:51:52PM +0800, Qu Wenruo wrote:
>>> Use kernel workqueue to implement a new btrfs_workqueue_struct, which
>>> has the ordering execution feature like the btrfs_worker.
>>>
>>> The func is executed in a concurrency way, and the
>>> ordred_func/ordered_free is executed in the sequence them are queued
>>> after the corresponding func is done.
>>> The new btrfs_workqueue use 2 workqueues to implement the original
>>> btrfs_worker, one for the normal work and one for ordered work.
>>>
>>> At this patch, high priority work queue or thresholding is not added yet.
>>> The high priority feature and thresholding will be added in the following patches.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: Josef Bacik <jbacik@fusionio.com>
>>
> Keep in mind I agree with Stefan and Dave's comments so please make those
> changes, but after that you can add my reviewed by.  Thanks,
>
> Josef
>
I'll apply the Stefan and Dave's comments in the next versionwith
more benchmarks.

Thanks.

Qu

-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

