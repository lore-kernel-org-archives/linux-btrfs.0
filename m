Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:45505 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbdKXIVS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 03:21:18 -0500
Received: by mail-vk0-f67.google.com with SMTP id s141so7298272vkb.12
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 00:21:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com> <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com> <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 24 Nov 2017 13:50:36 +0530
Message-ID: <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
Subject: Re: misc/021-image-multi-devices fails on latest btrfs-devel/misc-next
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay thanks for the details on btrfs-image. I was about to try with
previous version of
btrfs-image.

I'll use v4.14 (https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.tar.xz)
and check
again.

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Fri, Nov 24, 2017 at 1:36 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年11月24日 15:47, Lakshmipathi.G wrote:
>> Hi Qu,
>>
>> I'm using btrfs-progs devel branch. mount command is failing with misc/021.
>> When I tried to manually mount it. dmesg shows  "unrecognized super
>> flag: 17179869184"
>> and interestingly "df -h" shows 16E as available!
>
> That flag is meta dump flag, any image recovered from btrfs-image should
> have that flag.
>
> 16E may also related to that, but not a big problem as btrfs-image
> result should only be used by developers, and all its data is wiped out.
> (Maybe one day we will not allow RW mount for such image)
>
>
> The problem happens when you try to mount the image, there may be some
> new commits doing more restrict check for rw mount in devel branch.
>
> Would you please try v4.14 kernel?
>
> Thanks,
> Qu
>
>>
>> https://asciinema.org/a/4JGYg7YGQz1PHtdBRJ6AVw0fh
>>
>> Let me check further.
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org
>>
>>
>> On Fri, Nov 24, 2017 at 9:55 AM, Lakshmipathi.G
>> <lakshmipathi.g@gmail.com> wrote:
>>> Hi Qu,
>>>
>>> I'm using the same instance. Let me check again with and without the
>>> commits list on Nov-23
>>> (https://github.com/kdave/btrfs-devel/commits/misc-next) and get back
>>> with results.
>>>
>>> ----
>>> Cheers,
>>> Lakshmipathi.G
>>> http://www.giis.co.in http://www.webminal.org
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
