From: Josh Berry <des@condordes.net>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 13:28:03 -0700
Message-ID: <AANLkTik=t4mWvSOzLbFR3M7RbxgS=9WAFraj3XUguMLF@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
	<201008201403.41330.kreijack@libero.it>
	<AANLkTinfTtUvYSf7u0F8vE4BK_7891u1Cr7irc8FdUaa@mail.gmail.com>
	<4C6ECAA3.6010601@gmail.com>
	<AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
	<4C6ED0C8.2080505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6ED0C8.2080505@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 20, 2010 at 12:00, Andreas Philipp
<philipp.andreas@gmail.com> wrote:
> =C2=A0On 20.08.2010 20:49, Josh Berry wrote:
>>
>> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
>> <philipp.andreas@gmail.com> =C2=A0wrote:
>>>
>>> =C2=A0On 20.08.2010 20:27, Josh Berry wrote:
>>>>
>>>> On Fri, Aug 20, 2010 at 05:03, Goffredo Baroncelli<kreijack@gmail.=
com>
>>>> =C2=A0wrote:
>>>>>
>>>>> On Thursday, 19 August, 2010, James Smith wrote:
>>>>>>
>>>>>> This patch randomizes the error codes and also fixes up some typ=
os
>>>>>
>>>>> including
>>>>>>
>>>>>> capitalization in the output.
>>>>>>
>>>>>> It would almost be nice to see a translation effort for the tool=
 as
>>>>>> well.
>>>>
>>>> [...]
>>>>>
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 fprintf(stderr, "ERR-A.11: in command '");
>>>>>
>>>>> I am not against this kind of error codes, but I prefer
>>>>>
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 fprintf(stderr, "Error 'ERR-A.11' in command
>>>>> '");
>>>>
>>>> As a layman/end user, I disagree. =C2=A0The former format is easie=
r for
>>>> shell scripts and the like to parse -- the error code can be extra=
cted
>>>> with a simple "cut -d: -f1".
>>>
>>> This makes no difference. A simple `cut -d " " -f1` would do the jo=
b in
>>> the
>>> second case.
>>
>> I think you meant -f2, and that still leaves the quotes hanging
>> around. =C2=A0So you'd need to cut -d" " -f2 |tr -d "'" . =C2=A0It's=
 not a big
>> deal either way, I just think the former is easier to work with.
>
> Sorry, of course -f2. But why not simply cut -d "'" -f 2?

Oh right, good point. :)  Though as Goffredo said, using the error
code is probably better anyway.

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
