From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 21:00:24 +0200
Message-ID: <4C6ED0C8.2080505@gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>	<201008201403.41330.kreijack@libero.it>	<AANLkTinfTtUvYSf7u0F8vE4BK_7891u1Cr7irc8FdUaa@mail.gmail.com>	<4C6ECAA3.6010601@gmail.com> <AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 20.08.2010 20:49, Josh Berry wrote:
> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
> <philipp.andreas@gmail.com>  wrote:
>>   On 20.08.2010 20:27, Josh Berry wrote:
>>> On Fri, Aug 20, 2010 at 05:03, Goffredo Baroncelli<kreijack@gmail.com>
>>>   wrote:
>>>> On Thursday, 19 August, 2010, James Smith wrote:
>>>>> This patch randomizes the error codes and also fixes up some typos
>>>> including
>>>>> capitalization in the output.
>>>>>
>>>>> It would almost be nice to see a translation effort for the tool as
>>>>> well.
>>> [...]
>>>> +                       fprintf(stderr, "ERR-A.11: in command '");
>>>>
>>>> I am not against this kind of error codes, but I prefer
>>>>
>>>> +                       fprintf(stderr, "Error 'ERR-A.11' in command '");
>>> As a layman/end user, I disagree.  The former format is easier for
>>> shell scripts and the like to parse -- the error code can be extracted
>>> with a simple "cut -d: -f1".
>> This makes no difference. A simple `cut -d " " -f1` would do the job in the
>> second case.
> I think you meant -f2, and that still leaves the quotes hanging
> around.  So you'd need to cut -d" " -f2 |tr -d "'" .  It's not a big
> deal either way, I just think the former is easier to work with.
Sorry, of course -f2. But why not simply cut -d "'" -f 2?
Andreas
