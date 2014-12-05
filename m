Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932820AbaLEBMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 20:12:00 -0500
Message-ID: <5481065C.8090901@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 09:11:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Ed Tomlinson <edt@aei.ca>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com> <2026580.dXZxrES2AW@grover> <547EB7F1.9090408@jp.fujitsu.com> <547EBE9F.3070805@cn.fujitsu.com> <20141204172022.GG9754@twin.jikos.cz>
In-Reply-To: <20141204172022.GG9754@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月05日 01:20
> On Wed, Dec 03, 2014 at 03:41:19PM +0800, Qu Wenruo wrote:
>>> How about making lost+found on mkfs.btrfs like ext4?
>>>
>> I hope most user won't see the lost+found dir.
> ...
>> So lost+found should only occur when it is needed, and when it is needed
>> it will be created.
> Ack, as was mentioned before, lost+found is local to the containing
> subvolume so creating one for the whole filesystem at mkfs time is of no
> use.
>
> The usecase for creating the directory (compared to copying the files
> somewhere else) is to give a direct access to the files once the
> repaired filesystem is mounted again. Both should be implemented in the
> end.
Understood.
I'll also try if there is anything that can help btrfs-restore and 
backport it to restore later,
hoping later btrfsck patches can help both restore and btrfsck --repair.

Thanks,
Qu
