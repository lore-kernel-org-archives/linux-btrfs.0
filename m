From: Henti Smith <henti@geekware.co.za>
Subject: Re: Raid0 and drive failure.
Date: Sat, 17 Sep 2011 16:10:44 +0200
Message-ID: <CAC_HdUrwBYgVMGiFA8dHM5X=QSksQ37iyEWSSyDipqoKKTYEsw@mail.gmail.com>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
	<CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
	<CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
	<20110916151044.GF11031@carfax.org.uk>
	<CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
	<20110917113640.GA21530@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Henti Smith <henti@geekware.co.za>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110917113640.GA21530@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>> I've read some more on btrfs and one of the features listed as plann=
ed
>> is "Object-level RAID"
>> What will be the functional advantages of this as opposed to
>> filesystem level RAID.
>
> =A0 It'll mean that you can specify that individual files should be
> stored with different replication. (e.g. you could give the files
> containing your latest novel RAID-6 replication, but your CD
> collection RAID-0, all on the same filesystem).

Ahh ok this can be very handy, thanks :)

> =A0 It'll use exactly the same mechanisms that already exist in btrfs
> for replication, but will be configurable at finer levels of
> granularity (at least subvolumes, possibly down to individual files).
>
>> Would this not be the place to possibly add features to allow recove=
ry
>> of raid0 on an object level when a disk in the pool is lost, rather
>> than loosing all data ?
>
> =A0 I'm confused. How would you expect to recover a file on a broken
> RAID-0 when half (or 1/3, or whatever) of the data in it has gone awa=
y
> for good? The file is lost and gone forever. If you care somewhat
> about your data, use RAID-1, or -10 (or -5 or -6 when they arrive in
> btrfs[1]). If you really care about your data, keep off-machine and
> off-site backups -- RAID is not a backup.

That's just it, I don't care about my data that is lost when a drive
fails, I care about loosing all the data when only one drive fails.
Hence I'm trying to find out if there is a way to have fault tolerant
drive pooling.
After some more reading linear mode seems to offer the best options if
you can only discard the files in the FS that islost when a drive is
lost, but I'm still looking more into this.

At it's core I'm looking for a way to do something similar windows
drive extender that allows you to pool your drives without loosing all
your data when one drive is lost.

Regards
Henti
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
