From: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Tue, 8 Nov 2011 15:08:41 -0200
Message-ID: <CANkykrCfvFH_fg+5vJVkoWgcPuFp6euzVxZPTRDf=U+qrYUipA@mail.gmail.com>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
	<orzkgfwlom.fsf@livre.localdomain>
	<CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 1, 2011 at 9:20 PM, Gustavo Sverzut Barbieri
<barbieri@gmail.com> wrote:
> On Tue, Nov 1, 2011 at 7:57 PM, Alexandre Oliva <oliva@lsd.ic.unicamp=
=2Ebr> wrote:
>> Hi, Gustavo,
>>
>> On Nov =A01, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.com> wro=
te:
>>
>>> =A0 btrfs csum failed ino 2957021 extent 85041815552 csum 667310679
>>> wanted 0 mirror 0
>>
>>> Is there any way to recover it? =A0:-S
>>
>> Did you try mounting without data checksums?
>
> Just tried to mount with -o nodatasum, no luck. Is that enough?

Ideas? Should I give up and consider data lost? :-(

--=20
Gustavo Sverzut Barbieri
--------------------------------------
Mobile: +55 (19) 9225-2202
Contact: http://www.gustavobarbieri.com.br/contact
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
