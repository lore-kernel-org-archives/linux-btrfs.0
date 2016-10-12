Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755393AbcJLOyy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:54:54 -0400
Subject: Re: Btrfs progs build fails for 4.8
To: Abhay Sachan <lkp.abhay@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <CAKHchJwi-pEzaKkh72K-f+3ELA_H1VPiaoMGW7kgaHo_ZC3=4g@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <fa581ec0-b89b-fd5b-ffde-a4edb83e2ad8@redhat.com>
Date: Wed, 12 Oct 2016 09:54:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAKHchJwi-pEzaKkh72K-f+3ELA_H1VPiaoMGW7kgaHo_ZC3=4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/12/16 9:45 AM, Abhay Sachan wrote:
> Hi Qu,
> I am running latest 4.8.1, which I compiled on the machine itself.

You likely still have the fiemap.h from Centos' kernel-headers
rpm, which is from an older kernel and does not define it.
 
-Eric

> Linux vm88 4.8.1 #1 SMP Thu Oct 13 10:33:08 IST 2016 x86_64 x86_64
> x86_64 GNU/Linux
> 
> Regards,
> Abhay
> 
> On Wed, Oct 12, 2016 at 7:31 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
>>>
>>> Hi,
>>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
>>> with the error:
>>>
>>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
>>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
>>>
>>> Any ideas what am I lacking in the system?
>>
>>
>> Your kernel is too old and its header doesn't support FIEMAP_EXTENT_SHARED
>> flag for fiemap ioctl.
>>
>> And since that flag is very important for tools like "btrfs filesystem du",
>> for old kernel doesn't support EXTENT_SHARED flag, we have no choice but
>> abort configuration.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Regards,
>>> Abhay
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> 
> 

