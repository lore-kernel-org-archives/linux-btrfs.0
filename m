Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6544 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751214AbaJOOap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 10:30:45 -0400
Message-ID: <543E8510.8020000@fb.com>
Date: Wed, 15 Oct 2014 10:30:40 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Juan Orti Alcaine <juan.orti@miceliux.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
References: <543D555B.50708@pobox.com> <eff13bd09ee6883785a4be3ab005886b@miceliux.com> <543E7ACC.8080001@fb.com> <f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>
In-Reply-To: <f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2014 10:05 AM, Juan Orti Alcaine wrote:
> El 2014-10-15 15:46, Josef Bacik escribió:
>> On 10/15/2014 03:08 AM, Juan Orti Alcaine wrote:
>>> I've also experienced Btrfs corruptions with 3.17.0 (Fedora 21 alpha).
>>> It has happened two times, each one after a clean reinstall and a wipe
>>> of the old fs. In less than a day, both installations got corrupted and
>>> the filesystems went readonly. When listing the contents, I saw many
>>> directories with question marks.
>>>
>>> My system has 4 drives and 2 fs:
>>> - 1 SSD in single
>>> - 3 HDD in RAID1
>>
>> Did it happen on both fs'es or just one?  Thanks,
>>
>> Josef
>
> Both filesystems were corrupted. I have / in the SSD and /home in the HDDs.
>
> I didn't notice anything while working with the system, I only
> discovered the problem when booting up after the second or third reboot
> and seeing the service failing to start. Could it be something related
> to the mount/umount logic?
>

We've found it, the Fedora guys are reverting the bad patch now, we'll 
get the fix sent back to stable shortly.  Sorry about that.

Josef
