From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Fri, 12 Nov 2010 08:56:02 -0800
Message-ID: <AANLkTi=F+R55Kp3DzgHPz9BJY7v_fjqQ=yxD5cAsk1aJ@mail.gmail.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20101112074105.GD10179@dhcp231-156.rdu.redhat.com>
	<AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
	<201011122228.37322.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011122228.37322.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 12, 2010 at 6:28 AM, Marek Otahal <markotahal@gmail.com> wr=
ote:
> On Friday 12 of November 2010 18:44:12 you wrote:
>> On Thu, Nov 11, 2010 at 11:41 PM, Josef Bacik <josef@redhat.com> wro=
te:
>> > On Fri, Nov 12, 2010 at 05:47:14PM +1100, Chris Samuel wrote:
>> >> On 11/11/10 23:52, Josef Bacik wrote:
>> >> > This feature incurs a performance penalty in larger filesystems=
, it is
>> >> > recommended for use with filesystems of 1 GiB or smaller.
>> >>
>> >> Maybe slightly stronger, for example:
>> >>
>> >> This feature incurs a performance penalty for larger filesystems =
and it
>> >> is ONLY recommended for use with filesystems of 1 GiB or smaller.
>> >>
>> >> Is it worth having a check and a warning printed if a user does
>> >> try and make a filesystem larger than 1GiB with this option ?
>> >>
>> >> Just in case they don't RTFM...
>> >
>> > No because depending on your usage it's actually kind of usefull f=
or
>> > anything less than 5 GiB, and you're only looking at about a 5-10%=
 perf
>> > degredation when using it on larger filesystems. =C2=A0Thanks,
>>
>> Then a warning of 10% slowdown if > 10GB would be good. =C2=A0It's
>> surprising how many will just read some forum post and not concern
>> themselves with the docs at all.
>>
>> And making them type "yes" if > 100GB is probably a good idea too...
> My 2c: I'm against bloating the program just because of people who do=
n't RTFM.
> Just mention it clearly in docs and that's enough, linux does what it=
's asked
> for, not the "Are you really really sure you want to do this?" known =
from some
> other OS. Anyway, btrfs-progs would be probably run by a user with ro=
ot

I was thinking of what ssh does when it sees a changed key...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
