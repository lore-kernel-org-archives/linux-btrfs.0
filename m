From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Btrfs development plans
Date: Mon, 20 Apr 2009 21:18:00 +0400
Message-ID: <2a31deca0904201018t3635d08am9397a6d0a18aa1cc@mail.gmail.com>
References: <1240238253.16213.48.camel@think.oraclecorp.com>
	<20090420153118.GB6195@mother.fordon.pl.eu.org> <3da3b5b40904200910x63e4e26cqe058ce0e4bc7f8c8@mail.gmail.com>
	<2a31deca0904200957v39badd2eu4b26844e78fdcde3@mail.gmail.com>
	<e692861c0904201008q7b5484cbt902587640c17c5d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ahmed Kamal <email.ahmedkamal@googlemail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c0904201008q7b5484cbt902587640c17c5d9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2009 at 9:08 PM, Gregory Maxwell <gmaxwell@gmail.com> w=
rote:
> On Mon, Apr 20, 2009 at 12:57 PM, Andrey Kuzmin
> <andrey.v.kuzmin@gmail.com> wrote:
>> On Mon, Apr 20, 2009 at 8:10 PM, Ahmed Kamal
>> <email.ahmedkamal@googlemail.com> wrote:
>>>> =C2=A0But now Oracle can re-license Solaris and merge ZFS with btr=
fs.
>>>> Just kidding, I don't think it would be technically feasible.
>>>>
>>>
>>> May I suggest the name "ZbtrFS" :)
>>> Sorry couldn't resist. On a more serious note though, is there any
>>> technical benefits that justify continuing to push money in btrfs
>>
>> Personally, I don't see any. Porting zfs to Linux will cost (quite)
>> some time and effort, but this is peanuts compared to what's needed =
to
>> get btrfs =C2=A0(no offense meant) to maturity level/feature parity =
with
>> zfs. The only thing that could prevent this is CDDL licensing issues
>> and patent claims from NTAP over zfs snapshots =C2=A0and other featu=
res;
>> btrfs is free from both.
>
> I'm sure that people with far more experience than I will comment=E2=80=
=94
> But considering that BTRFS is in the Linux Kernel today, the historie=
s
> of other imported FSes (XFS),

Imported file-systems (someone more experienced may correct me if I'm
wrong) have previously been give-aways. This one is different - zfs is
in active development, with highly welcomed features like
de-duplication coming.

> and the state of ZFS in FreeBSD this may not be strictly true.

This was one-man's effort (though a heroic one, definitely), hardly a
case to compare with.


Regards,
Andrey
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
