Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:33498 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaJOOF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 10:05:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 15 Oct 2014 16:05:19 +0200
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Random file system corruption in 3.17 (not BTRFS
 =?UTF-8?Q?related=2E=2E=2E=3F=29?=
In-Reply-To: <543E7ACC.8080001@fb.com>
References: <543D555B.50708@pobox.com>
 <eff13bd09ee6883785a4be3ab005886b@miceliux.com> <543E7ACC.8080001@fb.com>
Message-ID: <f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El 2014-10-15 15:46, Josef Bacik escribió:
> On 10/15/2014 03:08 AM, Juan Orti Alcaine wrote:
>> I've also experienced Btrfs corruptions with 3.17.0 (Fedora 21 alpha).
>> It has happened two times, each one after a clean reinstall and a wipe
>> of the old fs. In less than a day, both installations got corrupted 
>> and
>> the filesystems went readonly. When listing the contents, I saw many
>> directories with question marks.
>> 
>> My system has 4 drives and 2 fs:
>> - 1 SSD in single
>> - 3 HDD in RAID1
> 
> Did it happen on both fs'es or just one?  Thanks,
> 
> Josef

Both filesystems were corrupted. I have / in the SSD and /home in the 
HDDs.

I didn't notice anything while working with the system, I only 
discovered the problem when booting up after the second or third reboot 
and seeing the service failing to start. Could it be something related 
to the mount/umount logic?

-- 
Juan Orti
https://miceliux.com

