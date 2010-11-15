From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Mon, 15 Nov 2010 10:28:44 -0600
Message-ID: <AANLkTincbPaGnVKjMzG+y6OPfn3hptE4Ffjn+rvJEhoN@mail.gmail.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20101112074105.GD10179@dhcp231-156.rdu.redhat.com>
	<AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
	<201011122228.37322.markotahal@gmail.com>
	<AANLkTi=F+R55Kp3DzgHPz9BJY7v_fjqQ=yxD5cAsk1aJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marek Otahal <markotahal@gmail.com>, linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=F+R55Kp3DzgHPz9BJY7v_fjqQ=yxD5cAsk1aJ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 12, 2010 at 10:56 AM, Mike Fedyk <mfedyk@mikefedyk.com> wro=
te:
> On Fri, Nov 12, 2010 at 6:28 AM, Marek Otahal <markotahal@gmail.com> =
wrote:
>> On Friday 12 of November 2010 18:44:12 you wrote:
>>> On Thu, Nov 11, 2010 at 11:41 PM, Josef Bacik <josef@redhat.com> wr=
ote:
>>> > On Fri, Nov 12, 2010 at 05:47:14PM +1100, Chris Samuel wrote:
>>> >> On 11/11/10 23:52, Josef Bacik wrote:
>>> >> > This feature incurs a performance penalty in larger filesystem=
s, it is
>>> >> > recommended for use with filesystems of 1 GiB or smaller.
>>> >>
>>> >> Maybe slightly stronger, for example:
>>> >>
>>> >> This feature incurs a performance penalty for larger filesystems=
 and it
>>> >> is ONLY recommended for use with filesystems of 1 GiB or smaller=
=2E
>>> >>
>>> >> Is it worth having a check and a warning printed if a user does
>>> >> try and make a filesystem larger than 1GiB with this option ?
>>> >>
>>> >> Just in case they don't RTFM...
>>> >
>>> > No because depending on your usage it's actually kind of usefull =
for
>>> > anything less than 5 GiB, and you're only looking at about a 5-10=
% perf
>>> > degredation when using it on larger filesystems. =A0Thanks,
>>>
>>> Then a warning of 10% slowdown if > 10GB would be good. =A0It's
>>> surprising how many will just read some forum post and not concern
>>> themselves with the docs at all.
>>>
>>> And making them type "yes" if > 100GB is probably a good idea too..=
=2E
>> My 2c: I'm against bloating the program just because of people who d=
on't RTFM.
>> Just mention it clearly in docs and that's enough, linux does what i=
t's asked
>> for, not the "Are you really really sure you want to do this?" known=
 from some
>> other OS. Anyway, btrfs-progs would be probably run by a user with r=
oot
>
> I was thinking of what ssh does when it sees a changed key...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thanks for the input everybody.

=46or now, I'm going to leave the man page entry relatively simple to
stay consistent with the level of information provided by the other
switches.

I'll submit the updated patch in a fresh post to the M/L.

I see a lot of activity in patch submissions for btrfs-progs, so if
anybody would like me to rework this patch or the parent patch on
implementing data+metadata in btrfs-progs for any reason, let me know.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
