Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40442 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbaGWBX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 21:23:57 -0400
Message-ID: <53CF0EA9.7030200@cn.fujitsu.com>
Date: Wed, 23 Jul 2014 09:23:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RESEND 1/4] btrfs-progs: Check fstype in find_mount_root()
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com> <20140722191559.GJ1553@twin.jikos.cz>
In-Reply-To: <20140722191559.GJ1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David, thanks for all the comments about the 'fi di' related patchset.

-------- Original Message --------
Subject: Re: [PATCH RESEND 1/4] btrfs-progs: Check fstype in 
find_mount_root()
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月23日 03:15
> On Thu, Jul 10, 2014 at 11:05:10AM +0800, Qu Wenruo wrote:
>> When calling find_mount_root(), caller in fact wants to find the mount
>> point of *BTRFS*.
>>
>> So also check ent->fstype in find_mount_root() and output proper error
>> messages if needed.
> The utils.c functions should be mostly silent about the errors as this
> this the common code and it's up to the callers to print the messages.
> The existing printf in find_mount_root had appeared before the function
> was moved to utils.c.
Thanks for the info about convention in utils.c
I'll update the patch and remove the printf from the original codes and 
my patches.

>
>> This will suppress a lot of "Inapproiate ioctl for device" error
>> message.
> Catching the error early is a good thing of course.
BTW, I did not see the patchset the latest integration branch, so after 
all the update about the patchset,
should I resend the patchset rebased on the latest integration branch?

Thanks,
Qu.
