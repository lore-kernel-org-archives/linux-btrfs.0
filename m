Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:59587 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGCRdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 13:33:10 -0400
Message-ID: <53B594E7.9070500@inwind.it>
Date: Thu, 03 Jul 2014 19:37:43 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com>
In-Reply-To: <53B4A3C7.1020805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2014 02:28 AM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with different ro/rw options"
> From: Goffredo Baroncelli <kreijack@libero.it>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014年07月03日 01:48
>> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>>> This commit has the following problem:
>>> 1) Break the ro mount rule.
>>> When users mount the whole btrfs ro, it is still possible to mount
>>> subvol rw and change the contents. Which make the whole fs ro mount
>>> non-sense.
>> Where is the problem ? I see an use case when I want a conservative default: mount all ro except some subvolumes.
>>
>> In any case it is not a security problem because if the user has the capability to mount a subvolume, also he has the capability to remount,rw the whole filesystem.
>>
>>
>>
> Not security problem but behavior not consistent.
> If user mount the whole disk ro, he or she want the fs read only and nothing will change in it.
> If you mount a subvol rw, then the whole disk ro expectation is broken. Things will change even the whole
> disk is readonly.

Sorry for bother you again, but there is a thing not clear to me:

If

    # mount -o subvolid=5,ro /dev/sda1 /mnt/root
    # mount -o subvol=subvolname,rw /dev/sda1 /mnt/subvolname

I suppose that 

    # touch /mnt/root/touch-test 		# 1

fails, and

    # touch /mnt/subvolname/touch-test		# 2

succeeded. I understood correctly ? If so this behaviour seems to me correctly.
Different is after mounting the subvolume "subvolumename", also the whole filesystem results rw (eg: #1 succeeded).

G.Baroncelli





> 
> The problem also happens when a parent subvol is mounted rw but child subvol is mounted ro.
> User can still modify the child subvol through parent subvol, still broke the readonly rule.
> 
> Thanks,
> Qu
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
