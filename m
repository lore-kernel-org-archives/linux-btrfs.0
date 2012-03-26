From: Alexander Block <ablock84@googlemail.com>
Subject: Re: btrfs and backups
Date: Mon, 26 Mar 2012 16:35:39 +0200
Message-ID: <CAB9VWqBdi2PLGnhHJ1uKOhtf0hcWck_Ev3vM0Z+MtaG=O_4K_A@mail.gmail.com>
References: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
	<4F702F54.90300@gmail.com>
	<CAG1y0scd6L75=m=en1+52gATpYKvvzo55E5PvxNcbqfuy7uCDg@mail.gmail.com>
	<pan.2012.03.26.14.26.12@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.03.26.14.26.12@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2012 at 4:26 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Fajar A. Nugraha posted on Mon, 26 Mar 2012 16:01:54 +0700 as excerpt=
ed:
>
>> On Mon, Mar 26, 2012 at 3:56 PM, Felix Blanke <felixblanke@gmail.com=
>
>> wrote:
>>> On 3/26/12 10:30 AM, James Courtier-Dutton wrote:
>>>> Is there some tool like rsync that I could copy all the data and
>>>> snapshots to a backup system, but still only use the same amount o=
f
>>>> space as the source filesystem.
>>
>>
>>> I'm not sure if I understand your problem right, but I would sugges=
t:
>>>
>>> 1) Snapshot the subvolume on the source 2) rsync the snapshot to th=
e
>>> destination 3) Snapshot the destination
>>
>> James did say "only use the same amount of space as the source
>> filesystem." Your approach would increase the usage when one or more
>> subvolume shares the same space (e.g. when one subvolume starts as
>> snapshot).
>>
>> AFAIK the (planned) way to do this is using "btrfs send | receive",
>> which is not available yet.
>
> What about rsyncing the snapshots, one at a time, snapshotting on the
> destination after each one? =A0I think that's what Felix' idea was.
>
> On the source filesystem, if each of the snapshots is mounted in turn=
 and
> rsynced across, then rsync should only catch the differences between =
the
> previous and currently rsyncing snapshots.
>
> On the destination, after the first rsync, a snapshot could be taken =
and
> mounted, so the second rsync is cumulative. =A0Then a second snapshot=
 can
> be taken, then it mounted, for the next rsync. =A0Given COW, I'd thin=
k
> that'd work.
>
> That's in contrast to an attempted rsync of the root filesystem, whic=
h
> would appear to rsync as if each snapshot was a separate directory tr=
ee,
> which would indeed kill the data sharing between them, thus taking up=
 N
> times the space of one snapshot on the destination.
>
> But if each snapshot is mounted in turn on both sides, destination of
> course trailing source by one snapshot, in theory at least, it should
> work, tho it depends on the rsync implementation being COW-friendly a=
nd
> I'm not positive it is but expect that it should be.
>
> Here, I'd probably do it manually the first few snapshot generations,
> checking usage on the destination to see that it was working as inten=
ded
> as I went and ensuring I had the process down, then script parts of i=
t,
> automating the parts, before ultimately combining the scripts into a =
full
> automation that, depending on the intent, could ideally be run from a=
 cron
> job or the like.
>
> --
> Duncan - List replies preferred. =A0 No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master." =A0Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

I used this style of incremental backups for some time and it works wel=
l
if you ignore the low performance when backing up very large files
(e.g. VM images).
I'm not 100% sure about this, but I think it's important to use the --i=
nplace
option of rsync if you want to preserve COW. If not used with --inplace=
,
rsync will create a new file every and after syncing, replace the orifi=
nal. This
will prevent COW at the moment.
Maybe this won't be required in the future when something like auto
deduplication is implemented, but I currently don't know about the plan=
s
for this feature.
however,
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
