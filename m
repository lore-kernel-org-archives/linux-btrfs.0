From: David Nicol <davidnicol@gmail.com>
Subject: Re: IOCTL #21 part two: btrfs progs patch, including iso 8601 timeout support
Date: Thu, 7 Oct 2010 10:50:30 -0500
Message-ID: <AANLkTikApZDmSDKw6+yFs9Ahvn5XX0ULwE6Of+FkN872@mail.gmail.com>
References: <AANLkTim0NC5QRs_z=tA8R5R4J07aQ7LS-Ls17t2Qvd7p@mail.gmail.com>
 <201010070810.42505.kreijack@libero.it> <AANLkTimGqfcdkQ_y_+z7Ch56fCWqXvwrtfE-vuncn5yP@mail.gmail.com>
 <AANLkTine=HRxuXFZ4e44UMsAs+j4XmZj9h4n_eZYegNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTine=HRxuXFZ4e44UMsAs+j4XmZj9h4n_eZYegNg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 7, 2010 at 9:25 AM, David Nicol <davidnicol@gmail.com> wrot=
e:
> anyway I think I got the logic wrong: the function as given yesterday
> would misparse
>
> =C2=A0 PT1M1M

no it wouldn't! because of the post-increment on the how-to-parse 'M'
state variable, the BIGM label can only get jumped to the first time,
and not following T, W, D or H. Rearranging it to have a forward jump
would lose this.

Better to have an initial sanity-check pass to verify that all
non-numerics are expected and in an acceptable order, and switch one
of the kinds of Ms to some other letter at that time, then zip through
the pieces with a case statement with no logic in it at all, just
stacked multiplications.

Goffredo -- this thinking-out-loud is not noise?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
