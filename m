From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Btrfs development plans
Date: Mon, 20 Apr 2009 20:57:10 +0400
Message-ID: <2a31deca0904200957v39badd2eu4b26844e78fdcde3@mail.gmail.com>
References: <1240238253.16213.48.camel@think.oraclecorp.com>
	<20090420153118.GB6195@mother.fordon.pl.eu.org> <3da3b5b40904200910x63e4e26cqe058ce0e4bc7f8c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40904200910x63e4e26cqe058ce0e4bc7f8c8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2009 at 8:10 PM, Ahmed Kamal
<email.ahmedkamal@googlemail.com> wrote:
>> =C2=A0But now Oracle can re-license Solaris and merge ZFS with btrfs=
=2E
>> Just kidding, I don't think it would be technically feasible.
>>
>
> May I suggest the name "ZbtrFS" :)
> Sorry couldn't resist. On a more serious note though, is there any
> technical benefits that justify continuing to push money in btrfs

Personally, I don't see any. Porting zfs to Linux will cost (quite)
some time and effort, but this is peanuts compared to what's needed to
get btrfs  (no offense meant) to maturity level/feature parity with
zfs. The only thing that could prevent this is CDDL licensing issues
and patent claims from NTAP over zfs snapshots  and other features;
btrfs is free from both.

Regards,
Andrey

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
