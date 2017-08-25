Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34109 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757242AbdHYRbl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 13:31:41 -0400
Received: by mail-qk0-f176.google.com with SMTP id a77so2370735qkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 10:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
 <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Fri, 25 Aug 2017 23:01:10 +0530
Message-ID: <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
Subject: Re: status of inline deduplication in btrfs
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 6:39 AM, Tsutomu Itoh <t-itoh@jp.fujitsu.com> wrote:
> On 2017/08/23 23:52, shally verma wrote:
>> HI
>>
>> Through btrfs wiki, I got to know about inline patch and this git
>> location https://github.com/adam900710/linux but I am not sure what's
>> progress and status on this. Could any one please confirm what is the
>> status of inline  deduplication into btrfs and if it is the correct
>> location to see its support?
>
> Lu Fengqi has posted the latest patchset (v14.4).
> https://marc.info/?l=linux-btrfs&m=149984943031184&w=2
>
> Unfortunately, it has not been committed yet.
>
Thanks for your response, I will go through patches. Could you also
help with answer to this question " what's
progress and status on this".  Do we have any test run reports that
tell about its stability levels, performance metric and other known
issues?
and possibly a roadmap of commit?

Thanks
Shally

> Thanks,
> Tsutomu
>
>>
>> Thanks
>> Shally
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
