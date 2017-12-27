Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:42119 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbdL0VkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 16:40:11 -0500
Received: by mail-ot0-f176.google.com with SMTP id 14so5893770oth.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Dec 2017 13:40:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAMvbhHV=BvRLv14U0JRrYmhiXeREOTNiVLPkuq=MO6dH4jDiQ@mail.gmail.com>
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
 <VI1PR08MB03368FD615EFAF0C3BB6195B92030@VI1PR08MB0336.eurprd08.prod.outlook.com>
 <CAAMvbhHV=BvRLv14U0JRrYmhiXeREOTNiVLPkuq=MO6dH4jDiQ@mail.gmail.com>
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Wed, 27 Dec 2017 21:39:30 +0000
Message-ID: <CAAMvbhG62rbphgWXQ_UiHHtH89wpsZXaLU0mut+4E+uuK2nbFw@mail.gmail.com>
Subject: Re: btrfs balance problems
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thank you for your suggestion.
It does not help at all.
btrfs balance's behaviour seems to be unchanged by ionice.
It still takes 100% while working and starves all other processes of
disk access.

I can I get btrfs balance to work in the background, without adversely
affecting other applications?

>
> On 23 December 2017 at 11:56, Alberto Bursi <alberto.bursi@outlook.it> wrote:
>>
>>
>> On 12/23/2017 12:19 PM, James Courtier-Dutton wrote:
>>> Hi,
>>>
>>> During a btrfs balance, the process hogs all CPU.
>>> Or, to be exact, any other program that wishes to use the SSD during a
>>> btrfs balance is blocked for long periods. Long periods being more
>>> than 5 seconds.
>>> Is there any way to multiplex SSD access while btrfs balance is
>>> operating, so that other applications can still access the SSD with
>>> relatively low latency?
>>>
>>> My guess is that btrfs is doing a transaction with a large number of
>>> SSD blocks at a time, and thus blocking other applications.
>>>
>>> This makes for atrocious user interactivity as well as applications
>>> failing because they cannot access the disk in a relatively low latent
>>> manner.
>>> For, example, this is causing a High Definition network CCTV
>>> application to fail.
>>>
>>> What I would really like, is for some way to limit SSD bandwidths to
>>> applications.
>>> For example the CCTV app always gets the bandwidth it needs, and all
>>> other applications can still access the SSD, but are rate limited.
>>> This would fix my particular problem.
>>> We have rate limiting for network applications, why not disk access also?
>>>
>>> Kind Regards
>>>
>>> James
>>>
>>
>> On most I/O intensive programs in Linux you can use "ionice" tool to
>> change the disk access priority of a process. [1]
>> This allows me to run I/O intensive background scripts in servers
>> without the users noticing slowdowns or lagging, of course this means
>> the process doing heavy I/O will run more slowly or get outright paused
>> if higher-priority processes need a lot of access to the disk.
>>
>> It works on btrfs balance too, see (commandline example) [2].
>>
>> If you don't start the process with ionice as in [2], you can always
>> change the priority later if you get the get the process ID. I use iotop
>> [3], which also supports commandline arguments to integrate its output
>> in scripts.
>>
>> For btrfs scrub it seems to be possible to specify the ionice options
>> directly, while btrfs balance does not seem to have them (would be nice
>> to add them imho). [4]
>>
>> For the sake of completeness, there is also "nice" tool for CPU usage
>> priority (also used in my scripts on servers to keep the scripts from
>> hogging the CPU for what is just a background process, and seen in [2]
>> commandline too). [5]
>>
>> 1. http://man7.org/linux/man-pages/man1/ionice.1.html
>> 2.
>> https://unix.stackexchange.com/questions/390480/nice-and-ionice-which-one-should-come-first
>> 3. http://man7.org/linux/man-pages/man8/iotop.8.html
>> 4. https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
>> 5. http://man7.org/linux/man-pages/man1/nice.1.html
>>
>> -Alberto
