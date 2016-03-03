Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36491 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814AbcCCVVz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 16:21:55 -0500
Received: by mail-wm0-f42.google.com with SMTP id n186so8395891wmn.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 13:21:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$54754$3acbb0c8$6074e95a$678977e7@cox.net>
References: <CAD=QJKiB9m_F+6AgmSJT_Dsd9HLBhXjEDFAcy6wLQNzO1DOkbQ@mail.gmail.com>
	<pan$54754$3acbb0c8$6074e95a$678977e7@cox.net>
Date: Thu, 3 Mar 2016 16:21:53 -0500
Message-ID: <CAD=QJKh2ugTHe7OyHniPL0dXm9wXZ3ur3-SSUTCAUWB2ZHRT9Q@mail.gmail.com>
Subject: Re: incomplete conversion to RAID1?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

> Of course either way assumes you don't run into some bug that will
> prevent removal of that chunk, perhaps exactly the same one that kept it
> from being removed during the normal raid1 conversion.  If that happens,
> the devs may well be interested in tracking it down, as I'm not aware of
> anything similar being posted to the list.

I've made up-to-date backups of this volume.  Is one of these two
methods more likely to trigger a potential bug?  Also, this potential
bug, if it's not just cosmetic wouldn't silently corrupt something in
my pool, right?  It's when things won't fail loudly and immediately
that concerns me, but if that's not an issue then I'd prefer to try to
gather potentially useful data.

Thanks again for such a great, and super informative reply.  I've been
swamped with work so haven't finished replying to your last one (Re:
btrfs-progs4.4 with linux-3.16.7 (with truncation of extends patch),
Fri, 05 Feb 2016 21:58:26 -0800).  To briefly reply: The last 3.5
years I've spent countless hours reading everything I could find on
btrfs and zfs, and I chose to start testing btrfs in the fall of 2015.
Currently I'm working on a major update of the Debian wiki btrfs page,
I plan to package kdave's btrfsmaintenance scripts, and additionally
publish some convenience scripts I use to make staying up-to-date with
one's preferred LTS kernel a two-command affair.

One thing I'd like to see on btrfs.wiki.kernel.org is an "at a glance"
table of ranked btrfs features, according to riskiness.  Say: 1)
Safest configuration; keep backups, as always, just in case.  2)
Features that might causes issues or that only occasionally trigger
issues.  3) Still very experimental; only people who intend to help
with development and debugging should use these.  4) Risk of corrupted
data, your backups are useless.  The benefit is then all
distributions' wikis could point to this table.  I've read OpenSuSE
has patches to disable features in at least 3), and 4), and maybe in
2), so maybe it wouldn't be useful for them...but for everyone else...
:-)

Also, I think that it would be neat to have a list of subtle bugs that
could benefit from more people trying to find them, and also a list of
stuff to test that will provide the data necessary to help fix the
"btrfs pools need to be babysit" issues I've read so often about.  I'm
not really able to understand anything more complex than a simple
utility program, so the most I can help out with is writing reports,
documentation, packaging, and some distribution integration stuff.

I'll send more questions in our other thread wrt to updating the
Debian wiki next week.  It will be a bunch of stuff like "Does btrfs
send > to a file count as a backup as of linux-4.4.x, or should you
still be using another method?"

Kind regards,
Nicholas

On 3 March 2016 at 00:53, Duncan <1i5t5.duncan@cox.net> wrote:
> Nicholas D Steeves posted on Wed, 02 Mar 2016 20:25:46 -0500 as excerpted:
>
>> btrfs fi show
>> Label: none  uuid: 2757c0b7-daf1-41a5-860b-9e4bc36417d3
>>         Total devices 2 FS bytes used 882.28GiB
>>         devid    1 size  926.66GiB used 886.03GiB path /dev/sdb1
>>         devid    2 size  926.66GiB used 887.03GiB path /dev/sdc1
>>
>> But this is what's troubling:
>>
>> btrfs fi df /.btrfs-admin/
>> Data, RAID1: total=882.00GiB, used=880.87GiB
>> Data, single: total=1.00GiB, used=0.00B
>> System, RAID1: total=32.00MiB, used=160.00KiB
>> Metadata, RAID1: total=4.00GiB, used=1.41GiB
>> GlobalReserve, single: total=496.00MiB, used=0.00B
>>
>> Do I still have 1.00GiB that isn't in RAID1?
>
> You have a 1 GiB empty data chunk still in single mode, explaining both
> the extra line in btrfs fi df, and the 1 GiB discrepancy between the two
> device usage values in btrfs fi show.
>
> It's empty, so it contains no data or metadata, and is thus more a
> "cosmetic oddity" than a real problem, but wanting to be rid of it is
> entirely understandable, and I'd want it gone as well. =:^)
>
> Happily, it should be easy enough to get rid of using balance filters.
> There are at least a two such filters that should do it, so take your
> pick. =:^)
>
> btrfs balance start -dusage=0
>
> This is the one I normally use.  -d is of course for data chunks. usage=N
> says only balance chunks with less than or equal to N% usage, this
> normally being used as a quick way to combine several partially used
> chunks into fewer chunks, releasing the space from the reclaimed chunks
> back to unallocated.  Of course usage=0 means only deal with fully empty
> chunks, so they don't have to be rewritten at all and can be directly
> reclaimed.
>
> This used to be needed somewhat often, as until /relatively/ recent
> kernels (tho a couple years ago now, 3.17 IIRC), btrfs wouldn't
> automatically reclaim those chunks as it usually does now, and a manual
> balance had to be done to reclaim them.  Btrfs normally reclaims those on
> its own now, but probably missed that one somewhere in your conversion
> process.  But that shouldn't be a problem as you can do it manually. =:^)
>
> Meanwhile, a hint.  While btrfs normally reclaims usage=0 chunks on its
> own now, it still doesn't automatically reclaim chunks that actually
> still have some usage, and over time, it'll likely still end up with a
> bunch of mostly empty chunks, just not /completely/ empty.  These can
> still take all your unallocated space, creating problems when the other
> type of chunk needs a new allocation (normally it's data chunks that take
> the space, and metadata chunks that need a new allocation and can't get
> it because the data chunks are hogging it all, but I've seen at least one
> report of it going the other way, metadata hogging space and data being
> unable to allocate, as well).
>
> To avoid that, you'll want to keep an eye on the /unallocated/ space, and
> when it drops below say 10 GiB, do a balance with -dusage=20, or as you
> get closer to full, perhaps -dusage=50 or -dusage=70 (above that will
> take a long time and not get you much), or perhaps -musage instead of
> -dusage, if metadata used plus globalreserve total gets too far from
> metadata total. (global-reserve total comes from metadata and should be
> added to metadata used, tho if it ever says global-reserve used above 0,
> you know your filesystem is /very/ tight in regard to space usage, since
> it won't use the reserve until it really /really/ has to.)
>
> btrfs balance start -dprofiles=single
>
> This one again uses -d for data chunks only, with the profiles=single
> filter saying only balance single-profile chunks.  Since you have only
> the one and it's empty, again, it should simply delete it, returning the
> space it took to unallocated.
>
>
> Of course either way assumes you don't run into some bug that will
> prevent removal of that chunk, perhaps exactly the same one that kept it
> from being removed during the normal raid1 conversion.  If that happens,
> the devs may well be interested in tracking it down, as I'm not aware of
> anything similar being posted to the list.  But it does say zero usage,
> so by logic, either of the above balance commands should just remove it,
> actually pretty fast, as there's only a bit of accounting to do to remove
> it.  And if they don't, then it /is/ a bug, but I'm guessing they will.
> =:^)
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
