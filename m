Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62895 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbaJONq5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 09:46:57 -0400
Message-ID: <543E7ACC.8080001@fb.com>
Date: Wed, 15 Oct 2014 09:46:52 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Juan Orti Alcaine <juan.orti@miceliux.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
References: <543D555B.50708@pobox.com> <eff13bd09ee6883785a4be3ab005886b@miceliux.com>
In-Reply-To: <eff13bd09ee6883785a4be3ab005886b@miceliux.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2014 03:08 AM, Juan Orti Alcaine wrote:
> El 2014-10-14 18:54, Robert White escribió:
>> Howdy,
>>
>> So I run several gentoo systems and I upgraded two of them to kernel
>> 3.17.0
>>
>> One using BTRFS for root.
>> One using ext3 for root (via the ext4 driver)
>>
>> _Both_ systems exhibited strange behavior (long pauses and then hangs
>> requiring hard-power) within several hours. Both then had random
>> filesystem damage.
>>
>> On the BTRFS system much of my browser settings for firefox were
>> trashed, particularly the cookies and saved conifigurations for
>> add-ons (like which sites had scripts enabled/disabled in no-script)
>> etc.
>>
>> On the ext3/4 system there were several corruptions including a
>> pipe/special file with a large non-zero size that required I do a
>> "fsck -fyD /dev/sda3" to repair. (one comment from fsck was that the
>> pipe/special file "looked like a directory" or some such)
>>
>> So I can say that corruption is taking place, but I suspect it is
>> _not_ happening in the BTRFS specific code.
>>
>> (ASIDE: both systems are older amd64 using built-in radeon display
>> hardware.)
>>
>
> I've also experienced Btrfs corruptions with 3.17.0 (Fedora 21 alpha).
> It has happened two times, each one after a clean reinstall and a wipe
> of the old fs. In less than a day, both installations got corrupted and
> the filesystems went readonly. When listing the contents, I saw many
> directories with question marks.
>
> My system has 4 drives and 2 fs:
> - 1 SSD in single
> - 3 HDD in RAID1

Did it happen on both fs'es or just one?  Thanks,

Josef

