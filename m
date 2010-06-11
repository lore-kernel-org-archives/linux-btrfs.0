From: Palmer Cox <palmercox@gmail.com>
Subject: Re: bcp command not installed by Makefile
Date: Fri, 11 Jun 2010 19:01:52 -0400
Message-ID: <AANLkTilAno75C9HQuq8YcDVb6i6ZyzhY8tik36AQZ010@mail.gmail.com>
References: <AANLkTimRn1NJsivc6HD8W5K3QKQoPdmvfK54o6TOY37c@mail.gmail.com>
	<201006111412.07560.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006111412.07560.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

I guess not.  I thought that bcp was letting me do a reflink copy of a
file from one subvolume to the another while cp was not.  Anyway, I
looked through the code and realized that bcp was just falling back to
a regular copy. oh well.

-Palmer Cox


On Fri, Jun 11, 2010 at 8:12 AM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Friday 11 of June 2010 03:46:11 Palmer Cox wrote:
>> Is there a reason the bcp command isn't installed when running make
>> install? =A0If not, here is a really simple patch to add it to the
>> install.
>>
>> -Palmer Cox
>
> Does 'bcp' can do anything additional that the 'cp --reflink=3Dalways=
'?
>
> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>
> System Zarz=B1dzania Jako=B6ci=B1
> zgodny z norm=B1 ISO 9001:2000
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
