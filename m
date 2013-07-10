Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3GJKxC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 06:53:02 -0400
Message-ID: <51DD3D0C.3060908@hiperscan.com>
Date: Wed, 10 Jul 2013 12:53:00 +0200
From: =?ISO-8859-1?Q?Franziska_N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crashes
References: <51DA6039.9080107@hiperscan.com> <20130708132453.GH2260@localhost.localdomain>
In-Reply-To: <20130708132453.GH2260@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created a bug:

https://bugzilla.kernel.org/show_bug.cgi?id=60544

Am 08.07.2013 15:24, schrieb Josef Bacik:
> On Mon, Jul 08, 2013 at 08:46:17AM +0200, Franziska Näpelt wrote:
>> Hi everybody,
>>
>> we are using a btrfs RAID 1 with four 2TB hard drives on a Debian 7.1
>> (Kernel 3.9.6).
>>
>> After about one year of working, there was an error in messages log and the
>> filesystem was mounted read-only.
>>
>> After that I restarted the system but that doesn't fix the bug. The
>> btrfs-filesystem couldn't be mounted.
>>
>> I attach four logs:
>>
>> -> when the error occured
>> -> after the error occured
>> -> when rebooting the system
>> -> when I tried ti mount manually
>>
>> Before I rebuilt the filesystem (formatting everything and creating a new
>> btrfs-pool) I made a btrfs-image. I can provide it to you.
>>
>
> Can you file a bugzilla at bugzilla.kernel.org (make sure the component is set
> to btrfs) with all of this information and a link to the image, and the output
> of btrfsck?  Please use the most recent version of btrfs-progs
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
