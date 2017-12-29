Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43835 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdL2TaZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 14:30:25 -0500
Received: by mail-io0-f196.google.com with SMTP id k202so33768011ioe.10
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 11:30:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
In-Reply-To: <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com> <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com> <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com> <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com> <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
 <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
From: Stirling Westrup <swestrup@gmail.com>
Date: Fri, 29 Dec 2017 14:30:24 -0500
Message-ID: <CAJt7KB9d7yvE42gt+bVXVu8RxsVpD8BW15mM-ecjSFUdqNtUAg@mail.gmail.com>
Subject: Re: Hand Patching a BTRFS Superblock?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You were right! grep found two more signature blocks! How do I make use of them?

videon:~ # LC_ALL=C grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /dev/sde
65600:_BHRfS_M
26697111807:_BHRfS_M
26854350428:_BHRfS_M

On Thu, Dec 28, 2017 at 11:00 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年12月29日 11:35, Stirling Westrup wrote:
>> On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>
>>>
>>> I strongly recommend to do a binary search for magic number "5f42 4852
>>> 6653 5f4d" to locate the real offset (if it's offset, not a toasted image)
>>>
>> I don't understand, how would I do a binary search for that signature?
>>
> The most stupid idea is to use xxd and grep.
>
> Something like:
>
> # xxd /dev/sde | grep 5f42 -C1
>



-- 
Stirling Westrup
Programmer, Entrepreneur.
https://www.linkedin.com/e/fpf/77228
http://www.linkedin.com/in/swestrup
http://technaut.livejournal.com
http://sourceforge.net/users/stirlingwestrup
