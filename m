From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 20:45:54 +0300
Message-ID: <AANLkTikzUMwj0cEsxWT0JyBOwY4PdiR8LSa6+2_XLuUU@mail.gmail.com>
References: <4D821ED3.5050605@jan-o-sch.net> <AANLkTi=ckrr4BNSPxkMCveLAY7NyQ6SF6OzYHMnxC-rD@mail.gmail.com>
 <4D8246F2.8080104@jan-o-sch.net> <1300383616-sup-9254@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300383616-sup-9254@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2011 at 8:42 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Jan Schmidt's message of 2011-03-17 13:37:54 -0400:
>> On 03/17/2011 06:09 PM, Andrey Kuzmin wrote:
>> > On Thu, Mar 17, 2011 at 5:46 PM, Jan Schmidt <list.btrfs@jan-o-sch=
=2Enet
>> > <mailto:list.btrfs@jan-o-sch.net>> wrote:
>> > =C2=A0 =C2=A0 - Is it acceptable to retry reading a block immediat=
ely after the disk
>> > =C2=A0 =C2=A0 said it won't work? Or in case of a successful read =
followed by a
>> > =C2=A0 =C2=A0 checksum error? (Which is already being done right n=
ow in btrfs.)
>> >
>> >
>> > These are two pretty different cases. When disk firmware fails rea=
d, it
>> > means it has retried number of times but gave up (suggesting media
>> > error), so an upper layer retry would hardly make sense. Checksum =
error
>> > catches on-disk EDC fault, so retry is on the contrary quite reaso=
nable.
>>
>> Agreed.
>>
>> > =C2=A0 =C2=A0 - Is it acceptable to always write both mirrors if o=
ne is found to be
>> > =C2=A0 =C2=A0 bad (also consider ssds)?
>> >
>> >
>> > Writing on read path bypassing file-system transaction mechanism d=
oesn't
>> > seem a good idea to me. Just imaging loosing power while overwriti=
ng
>> > last good copy.
>>
>> Okay, sounds reasonable to me. Let's say we're bypassing transaction
>> mechanism in the same rude manner, but only write the bad mirror. Do=
es
>> that seem reasonable?
>
> The bad mirror is fair game. =C2=A0Write away, as long as you're sure=
 you're
> excluding nodatacow and you don't allow that block to get reallocated
> elsewhere. =C2=A0You don't actually need to bypass the transaction
> mechanism, just those two things.

What happens if multiple readers (allowed by read lock) attempt an over=
write?


Regards,
Andrey


>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
