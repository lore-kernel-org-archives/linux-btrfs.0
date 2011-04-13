From: =?UTF-8?Q?Ernst_Sj=C3=B6strand?= <ernstp@gmail.com>
Subject: Re: New btrfsck status
Date: Wed, 13 Apr 2011 16:00:15 +0200
Message-ID: <BANLkTik=AaPoFv5O_wnL4R_6EgJ_5iZUxw@mail.gmail.com>
References: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com>
	<1297340143-sup-3602@think>
	<4D91CCCC.10305@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D91CCCC.10305@mandriva.org>
List-ID: <linux-btrfs.vger.kernel.org>

A very good question indeed! ;-)

Regards
//Ernst Sj=C3=B6strand

On Tue, Mar 29, 2011 at 14:13, Thomas Backlund <tmb@mandriva.org> wrote=
:
> Chris Mason skrev 10.2.2011 14:17:
>>
>> Excerpts from Ben Gamari's message of 2011-02-09 21:52:20 -0500:
>>>
>>> Hey all,
>>>
>>> Over the last several months there have been many claims regarding =
the
>>> release of the rewritten btrfsck. Unfortunately, despite numerous
>>> claims that it will be released Real Soon Now(c), I have yet to see
>>> even a repository with preliminary code. Did I miss an announcement=
?
>>> There is something to be said for "release early, release often." I=
s
>>> there a timeline for getting btrfsck into some sort of usable form?
>>
>> Yes, but its still real soon now. =C2=A0I've been at about 90% done =
since
>> Christmas. =C2=A0It would have been out last week but I've been chas=
ing a
>> debugging a very difficult corruption under load.
>>
>> I finally found a race in btrfs causing the corruption and now I'm b=
ack
>> on fsck full time again.
>>
>
> Any status updates on this ?
>
> Checking:
> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-progs-unstabl=
e.git;a=3Dshortlog;h=3Drefs/heads/next
>
> I see last commit is 3+ months ago
>
> --
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
