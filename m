From: Josh Berry <des@condordes.net>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 11:27:05 -0700
Message-ID: <AANLkTinfTtUvYSf7u0F8vE4BK_7891u1Cr7irc8FdUaa@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
	<201008201403.41330.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008201403.41330.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 20, 2010 at 05:03, Goffredo Baroncelli <kreijack@gmail.com>=
 wrote:
> On Thursday, 19 August, 2010, James Smith wrote:
>> This patch randomizes the error codes and also fixes up some typos
> including
>> capitalization in the output.
>>
>> It would almost be nice to see a translation effort for the tool as =
well.
[...]
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr, "ERR-A.11: in command '");
>
> I am not against this kind of error codes, but I prefer
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr, "Error 'ERR-A.11' in command '");

As a layman/end user, I disagree.  The former format is easier for
shell scripts and the like to parse -- the error code can be extracted
with a simple "cut -d: -f1".

(In fact, I wish the output from things like "btrfs filesystem df",
"show", etc. were easier to parse, but that's a separate issue. :) )

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
