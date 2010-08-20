From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 07:43:42 -0500
Message-ID: <AANLkTi=fgMC2h86cJQzyHRzUF0M0eSMdoWFtrWrjHorc@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com> <201008201403.41330.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008201403.41330.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 20, 2010 at 7:03 AM, Goffredo Baroncelli <kreijack@gmail.co=
m> wrote:
>
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr, "ERR-A.11: in command '");
>
> I am not against this kind of error codes, but I prefer
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr, "Error 'ERR-A.11' in command '");
>
> And a file.txt which details the error codes (otherwise these errors =
are not
> very useful).
>
> Why some error codes contain a dot (see ERR-C.13) and others not (lik=
e ERR-
> A3) ?

Goffredo Baroncelli - I think those are good comments!

However, I would further suggest that when reporting an error code
that including the 'ERR-' prefix is redundant. Therefore, I propose:

fprintf(stderr, "Error 'A.11' in command '");

What does A. 11 refer to, anyway?

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
