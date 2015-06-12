Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15121 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751424AbbFLJJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 05:09:16 -0400
Message-ID: <557AA1B9.9040009@cn.fujitsu.com>
Date: Fri, 12 Jun 2015 17:09:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com> <557A8691.6070908@cn.fujitsu.com> <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
In-Reply-To: <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
From: Tomasz Chmielewski <tch@virtall.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年06月12日 16:35

> On 2015-06-12 16:13, Qu Wenruo wrote:
>
>>> Remote syslog does not capture anything.
>> No backtrace?
>
> No (nothing saved on disk, don't have VNC access).
>
> The only way to capture anything is:
>
> while true; do dmesg -c ; done
>
> but that's usually incomplete.
If your dmesg is up-to-date, dmesg -w should do it better than your script.
And normally, I can get a full trace with backtrace when kernel down 
with it.

And if it still can't get the full trace, then try kdump.

>
>
>> Without backtrace, it's much harder to debug for us.
>> It's quite possible that some codes go mad and pass a NULL pointer,
>> and then wait_event() is called on the NULL->some_member.
>>
>> Anyway, backtrace is needed to debug this.
>>
>> If syslog can't help, what about kdump + crash to get the backtrace?
>
> I'll try to get a kdump + crash.
>
IIRC, kernel from stock RHEL7/centos has kdump enabled.
You can try restart kdump service to see what's wrong.

Normally you just need to change the crashkernel=auto to some real number.

Lastly, it's better to use stock kernel with kdump/crash, or you need
a lot of kernel options from debuginfo to max cpu numbers to allow
stock crash able to get kernel log from it.

Thanks,
Qu
