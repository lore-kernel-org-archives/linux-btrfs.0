Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35650 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932835AbcJLOp4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:45:56 -0400
Received: by mail-ua0-f170.google.com with SMTP id r64so7033903uar.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 07:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
From: Abhay Sachan <lkp.abhay@gmail.com>
Date: Wed, 12 Oct 2016 20:15:35 +0530
Message-ID: <CAKHchJwi-pEzaKkh72K-f+3ELA_H1VPiaoMGW7kgaHo_ZC3=4g@mail.gmail.com>
Subject: Re: Btrfs progs build fails for 4.8
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,
I am running latest 4.8.1, which I compiled on the machine itself.

Linux vm88 4.8.1 #1 SMP Thu Oct 13 10:33:08 IST 2016 x86_64 x86_64
x86_64 GNU/Linux

Regards,
Abhay

On Wed, Oct 12, 2016 at 7:31 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 10/12/2016 09:58 PM, Abhay Sachan wrote:
>>
>> Hi,
>> I tried building latest btrfs progs on CentOS 6, "./configure" failed
>> with the error:
>>
>> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
>> configure: error: no definition of FIEMAP_EXTENT_SHARED found
>>
>> Any ideas what am I lacking in the system?
>
>
> Your kernel is too old and its header doesn't support FIEMAP_EXTENT_SHARED
> flag for fiemap ioctl.
>
> And since that flag is very important for tools like "btrfs filesystem du",
> for old kernel doesn't support EXTENT_SHARED flag, we have no choice but
> abort configuration.
>
> Thanks,
> Qu
>
>>
>> Regards,
>> Abhay
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Abhay
