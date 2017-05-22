Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35938 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757522AbdEVJrj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 05:47:39 -0400
Received: by mail-vk0-f47.google.com with SMTP id p85so37478666vkd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 02:47:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b57b3e03-fc72-762f-1392-9a4ccafd0fcb@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
 <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com> <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
 <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com> <CAKuJGC_LWzJKGPecweK93nXRm1=j22HkqZdUHrragwab6zAUDw@mail.gmail.com>
 <f0ed81f8-a312-72b0-5da1-56cfbc1fa81e@cn.fujitsu.com> <CAKuJGC9YY-1i-Hxq7=8E_pd19xOA7Tt0ckYEpwJhrgtSbardOA@mail.gmail.com>
 <CAKuJGC9UZ8cb8W_XcqVEPsv7UAi7P=UjY6Gb4Uo6A5GMMj5qmw@mail.gmail.com> <b57b3e03-fc72-762f-1392-9a4ccafd0fcb@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 22 May 2017 15:17:38 +0530
Message-ID: <CAKuJGC8-VEm-3afkVmWzk+kVdxHZECp1soyksN4fvEJkJkB2GA@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay sure, When I find free-time,  will run few more combinations and
let you know the details along with any other suggestions/thoughts on
the interface. thanks.

On 5/22/17, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Good to hear that.
>
> And you could try more combination (although I have done a lot during
> the test) to see if it's good enough to be used as a better scrub
> equivalent.
>
> And of course, any idea on the interface design (--offline under scrub
> or other place) is welcomed.
>
> Thanks,
> Qu
>
> At 05/22/2017 04:30 PM, Lakshmipathi.G wrote:
>> Yes. It detects the injected corruption.
>>
>> #btrfs scrub start --offline /dev/loop6
>> ERROR: data at bytenr 145293312 mirror 0 csum mismatch, have
>> 0x790f1fe1 expect 0xa30cb5c5
>> ERROR: full stripe 145227776 RECOVERABLE: Data stripes corrupted, but
>> P/Q is good
>>
>> Scrub result:
>> Tree bytes scrubbed: 131072
>> Tree extents scrubbed: 8
>> Data bytes scrubbed: 192512
>> Data extents scrubbed: 3
>> Data bytes without csum: 131072
>> Read error: 0
>> Verify error: 0
>> Csum error: 1
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>>
>>
>
>
>


-- 
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
