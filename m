From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Configuring default mount options..
Date: Mon, 26 Jul 2010 03:42:34 +0200
Message-ID: <AANLkTimOC0qyDdv3KgY4p_vcW1YQ+f=ToaS4=81VQh4B@mail.gmail.com>
References: <1280105806.3327.4.camel@hardline>
	<AANLkTikNemTBWO8ChQ-XYdP4gp=1zKt5EMyzdzLrxgWq@mail.gmail.com>
	<1280107386.3327.8.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1280107386.3327.8.camel@hardline>
List-ID: <linux-btrfs.vger.kernel.org>

On 26 July 2010 03:23, A. James Lewis <james@fsck.co.uk> wrote:
> On Mon, 2010-07-26 at 03:10 +0200, Sebastian 'gonX' Jensen wrote:
>> On 26 July 2010 02:56, A. James Lewis <james@fsck.co.uk> wrote:
>> > If using BTRFS on a removable drive... it may be a problem for exa=
mple,
>> > to always mount with compression, or always mount with encryption =
(If
>> > supported in future)... perhaps btrfstune could define default mou=
nt
>> > options, such as compression... so if there is a BTRFS filesystem =
on a
>> > removable hard drive, or flash stick, the filesystem can be config=
ured
>> > to mount with compression by default.
>> >
>> > Maybe there is a way to do this already, but it seems like the
>> > filesystem itself should contain preferences for the way it is use=
d
>> > under those circumstances.
>> >
>> > A. James Lewis
>> >
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >
>>
>> That's actually a good idea. Perhaps an override flag could be
>> specified in case you do not wish to use said default mount options?
>>
> Indeed, if any mount options are specified they would override
> defaults... but if you plug in a removable drive, you there's no way =
to
> specify mount options, but it's quite likley that you would want some=
,
> like compression for example.
>
>
>> Regards,
>> Sebastian J.
>
>
>

Oh, you're talking about udisks/HAL automount feature I assume. It
should be possible to specify mount parameters in some way for those
implementations, but that isn't really a "fix" if you're using
multiple computers - a per-drive mount parameter stored somewhere on
the drive wouldn't be that bad to save some time.

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
