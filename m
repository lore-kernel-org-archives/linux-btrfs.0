From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: lots of kernel threads
Date: Wed, 25 Feb 2009 11:13:50 -0800
Message-ID: <7a329d910902251113q55fd57b2u66bd5dc4e35c414a@mail.gmail.com>
References: <7a329d910902242009k6ae3fff7t8711ebc1a8bafea8@mail.gmail.com>
	 <1235584263.32346.10.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235584263.32346.10.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2009 at 9:51 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, 2009-02-24 at 20:09 -0800, Wil Reichert wrote:
>> I'm a Gentoo user and figured mounting /usr/portage & /var/portage
>> (distfiles, packages, persistent stuff normally in /usr/portage) and
>> /tmp moiunted as btrfs. =C2=A0I figured it would be a decent test & =
its
>> nothing I cann't replace readily. =C2=A0After about 6 hours of uptim=
e and a
>> couple package merges, I checked ps aux & am getting the following:
>>
>
> Btrfs has a number of thread pools per mounted filesystem. =C2=A0It m=
akes
> sense to switch the thread pools to be more global, but for right now
> these threads are not unusual.
>
> Kernel threads are lightweight enough that the only major downside to
> these is making ps output ugly ;)
>
> -chris

ps noise is fine, my only concern was that something was getting
created & not cleaned up.

Thanks,

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
