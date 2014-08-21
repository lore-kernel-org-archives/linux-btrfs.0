Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbaHUO3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 10:29:53 -0400
Message-ID: <53F60264.5090401@redhat.com>
Date: Thu, 21 Aug 2014 09:29:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
References: <53F51F4D.2090203@redhat.com> <53F5B18B.1030801@oracle.com>
In-Reply-To: <53F5B18B.1030801@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/21/14, 3:44 AM, Anand Jain wrote:
> 
> 
>  A long time back there was an attempt to remove it but
>  this avoided it. Pls ref to the link in this discussion.
> 
>  https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27272.html

Hm, I guess I don't understand this.  How is udev related to whether
or not /proc/partitions is sufficient vs. recursive /dev?

To be clear, my patchset keeps the -d / --all-devices option.

It simply discovers all devices via /proc/partitions, not via
a full /dev tree walk.

Thanks,
-Eric


> Thanks, Anand
> 
> On 08/21/2014 06:21 AM, Eric Sandeen wrote:
>> btrfs fileystem show and btrfs device scan today both have
>> the "-d" option to scan everything under /dev.  But we also
>> have a mechanism to scan everything in /proc/partitions, which
>> should always be sufficient.
>>
>> If anyone knows why we'd find something deep under /dev but
>> not in /proc/partitions, speak now or forever hold your peace...
>>
>> Tested this by running through a matrix of -d, -m, or "" args
>> for show/scan, for a 2-device fs, with and without a symlinked
>> device, with and without a symlinked mountpoint.  All output was
>> identical.
>>
>> Thanks,
>> -Eric
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

