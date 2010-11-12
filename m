From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Fri, 12 Nov 2010 09:59:32 -0600
Message-ID: <AANLkTikt6F8jNKqGbG9AOfgX1bRgxRdUpq2DfeUjudBR@mail.gmail.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20101111021034.GA6911@dhcp231-156.rdu.redhat.com>
	<AANLkTimmhCYFtq1y3Lda8O7CRTJOF4OLU-jkJ+yF965X@mail.gmail.com>
	<20101111125229.GA10179@dhcp231-156.rdu.redhat.com>
	<4CDCE2F2.5020500@csamuel.org>
	<20101112074105.GD10179@dhcp231-156.rdu.redhat.com>
	<AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>, Chris Samuel <chris@csamuel.org>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 12, 2010 at 4:44 AM, Mike Fedyk <mfedyk@mikefedyk.com> wrot=
e:
> On Thu, Nov 11, 2010 at 11:41 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> On Fri, Nov 12, 2010 at 05:47:14PM +1100, Chris Samuel wrote:
>>> On 11/11/10 23:52, Josef Bacik wrote:
>>>
>>> > This feature incurs a performance penalty in larger filesystems, =
it is
>>> > recommended for use with filesystems of 1 GiB or smaller.
>>>
>>> Maybe slightly stronger, for example:
>>>
>>> This feature incurs a performance penalty for larger filesystems an=
d it
>>> is ONLY recommended for use with filesystems of 1 GiB or smaller.
>>>
>>> Is it worth having a check and a warning printed if a user does
>>> try and make a filesystem larger than 1GiB with this option ?
>>>
>>> Just in case they don't RTFM...
>>>
>>
>> No because depending on your usage it's actually kind of usefull for=
 anything
>> less than 5 GiB, and you're only looking at about a 5-10% perf degre=
dation when
>> using it on larger filesystems. =A0Thanks,
>>
>
> Then a warning of 10% slowdown if > 10GB would be good. =A0It's
> surprising how many will just read some forum post and not concern
> themselves with the docs at all.
>
> And making them type "yes" if > 100GB is probably a good idea too...
>

Just for clarification, you'll probably see a ~5-10% slowdown for any
size partition, not just "if > 10 GB"

But for smaller filesystems (~<5 GiB), you may want to accept the
performance penalty for more efficient disk space utilization.

=46or really small filesystems (~<1 GiB), using Btrfs defaults can
really start to impact on space utilization.  So the parent
data+metadata patch currently forces the data+metadata option on <1
GiB.

The Wiki is probably a better place for more extensive discussion of
the merits and trade-offs of this option.

The user still needs to actively "opt-in" to this option (unless their
partition is < GiB), and the man page will indicate a performance
penalty is incurred.

=46or something as important as changing your filesystem default
settings, it seems fair to expect the user has done their homework
when changing from the default setting.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
