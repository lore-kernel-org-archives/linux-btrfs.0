Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5158 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbaGCA1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 20:27:53 -0400
Message-ID: <53B4A3C7.1020805@cn.fujitsu.com>
Date: Thu, 3 Jul 2014 08:28:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it>
In-Reply-To: <53B445F5.6060709@libero.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes 
with different ro/rw options"
From: Goffredo Baroncelli <kreijack@libero.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月03日 01:48
> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>> This commit has the following problem:
>> 1) Break the ro mount rule.
>> When users mount the whole btrfs ro, it is still possible to mount
>> subvol rw and change the contents. Which make the whole fs ro mount
>> non-sense.
> Where is the problem ? I see an use case when I want a conservative default: mount all ro except some subvolumes.
>
> In any case it is not a security problem because if the user has the capability to mount a subvolume, also he has the capability to remount,rw the whole filesystem.
>
>
>
Not security problem but behavior not consistent.
If user mount the whole disk ro, he or she want the fs read only and 
nothing will change in it.
If you mount a subvol rw, then the whole disk ro expectation is broken. 
Things will change even the whole
disk is readonly.

The problem also happens when a parent subvol is mounted rw but child 
subvol is mounted ro.
User can still modify the child subvol through parent subvol, still 
broke the readonly rule.

Thanks,
Qu
