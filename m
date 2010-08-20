From: Benjamin Griese <der.darude@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 16:42:46 +0200
Message-ID: <AANLkTikmka7G-+bCLeqKmQQXbBJp=GkHJDApYpup5t-d@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
	<201008201403.41330.kreijack@libero.it>
	<AANLkTi=fgMC2h86cJQzyHRzUF0M0eSMdoWFtrWrjHorc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=fgMC2h86cJQzyHRzUF0M0eSMdoWFtrWrjHorc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello guys,

I would also prefer doing it in an all-in-one tool with various paramet=
ers.
I like the concept how the Solaris-Devs did it by consolidating every
special configuration tool to an "xyzadm"-binary (idea: btrfsadm? i.e.
similar to mdadm?).
=46or me as an admin it is easier to remember only one command,
especially when its neccessery to use it only from time to time.
There exists only one manpage where every parameter is found (in theory=
). :)
And for the devs (sorry, I'm not one of those guys ;) ) maybe its
easier to maintain/improve only one binary + lib.

Just my opinion. :)

bye, benjamin


On Fri, Aug 20, 2010 at 14:43, Jon Nelson <jnelson@jamponi.net> wrote:
> On Fri, Aug 20, 2010 at 7:03 AM, Goffredo Baroncelli <kreijack@gmail.=
com> wrote:
>>
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "ERR-A=
=2E11: in command '");
>>
>> I am not against this kind of error codes, but I prefer
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "Error=
 'ERR-A.11' in command '");
>>
>> And a file.txt which details the error codes (otherwise these errors=
 are not
>> very useful).
>>
>> Why some error codes contain a dot (see ERR-C.13) and others not (li=
ke ERR-
>> A3) ?
>
> Goffredo Baroncelli - I think those are good comments!
>
> However, I would further suggest that when reporting an error code
> that including the 'ERR-' prefix is redundant. Therefore, I propose:
>
> fprintf(stderr, "Error 'A.11' in command '");
>
> What does A. 11 refer to, anyway?
>
> --
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
To be or not to be -- Shakespeare | To do is to be -- Nietzsche | To
be is to do -- Sartre | Do be do be do -- Sinatra
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
