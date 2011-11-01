From: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Tue, 1 Nov 2011 21:20:44 -0200
Message-ID: <CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
	<orzkgfwlom.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orzkgfwlom.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 1, 2011 at 7:57 PM, Alexandre Oliva <oliva@lsd.ic.unicamp.b=
r> wrote:
> Hi, Gustavo,
>
> On Nov =A01, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.com> wrot=
e:
>
>> =A0 btrfs csum failed ino 2957021 extent 85041815552 csum 667310679
>> wanted 0 mirror 0
>
>> Is there any way to recover it? =A0:-S
>
> Did you try mounting without data checksums?

Just tried to mount with -o nodatasum, no luck. Is that enough?


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
