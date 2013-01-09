Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42217 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3AIHXZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 02:23:25 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r097NOBI013007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:23:24 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r097NNYM017002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:23:24 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r097NN5v023123
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 01:23:23 -0600
Message-ID: <50ED1AE9.2050006@oracle.com>
Date: Wed, 09 Jan 2013 15:23:21 +0800
From: Simon Xu <xu.simon@oracle.com>
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] remove "device show" from btrfs man page
References: <1357713972-1581-1-git-send-email-xu.simon@oracle.com> <50ED18C5.8000107@oracle.com>
In-Reply-To: <50ED18C5.8000107@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sure, I'll make another patch.

Thanks
Simon

On 2013/1/9 15:14, Jeff Liu wrote:
> Hi Simon,
>
> For the next time when you post btrfs-progs related patches, please
> indicate it with a suffix "Btrfs-progs: " on the subject.
>
> Thanks,
> -Jeff
> On 01/09/2013 02:46 PM, Simon Xu wrote:
>> Remove "device show" from btrfs man page as it's not supported by the
>> btrfs utility.
>> ---
>>   man/btrfs.8.in | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
>> index 9222580..e663da2 100644
>> --- a/man/btrfs.8.in
>> +++ b/man/btrfs.8.in
>> @@ -33,8 +33,6 @@ btrfs \- control a btrfs filesystem
>>   .PP
>>   \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
>>   .PP
>> -\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
>> -.PP
>>   \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
>>   .PP
>>   \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
