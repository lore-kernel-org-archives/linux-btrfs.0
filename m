Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBPTSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 14:18:24 -0500
Message-ID: <53010EF9.60805@friedels.name>
Date: Sun, 16 Feb 2014 20:18:17 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name> <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com> <52F73E2B.9080103@friedels.name> <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com> <82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>
In-Reply-To: <82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

thanks for your hint.
 >> No. You said you need to recreate the file system, and only have 
these two devices and therefore must remove one device. You can't 
achieve that with raid1 which requires minimum two devices.
>>
>> -dconvert=single -mconvert=dup -sconvert=dup
>
> Actually, I'm reminded with multiple devices that dup might not be possible. Instead you might have to using single for all of them. Then remove the device you want removed. And then do another conversion for just -mconvert=dup -sconvert=dup, and do not specify -dconvert. That way the single metadata profile is converted to duplicate.

I think it didn't work.

btrfs balance start  -dconvert=single -mconvert=single -sconvert=single 
--force /mnt/BTRFS/Video/
After >10h:
  btrfs balance status /mnt/BTRFS/Video/
No balance found on '/mnt/BTRFS/Video/'
root@homeserver:~# btrfs fi df /mnt/BTRFS/Video/
Data, RAID0: total=4.00GB, used=4.00GB
Data: total=2.29TB, used=2.29TB
System: total=32.00MB, used=256.00KB
Metadata: total=4.00GB, used=2.57GB
root@homeserver:~# btrfs fi show
Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
         Total devices 2 FS bytes used 2.29TB
         devid    2 size 2.73TB used 1.15TB path /dev/sdc1
         devid    1 size 2.73TB used 1.15TB path /dev/sdb1


(you see that I cleaned up beforehand, so that enough space is 
available, generally).

Do you have an idea what could be wrong?


Thanks and Regards,
Hendrik


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
