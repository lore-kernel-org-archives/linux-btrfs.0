From: Henti Smith <henti@geekware.co.za>
Subject: Re: Raid0 and drive failure.
Date: Sat, 17 Sep 2011 09:20:28 +0200
Message-ID: <CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
	<CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
	<CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
	<20110916151044.GF11031@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Henti Smith <henti@geekware.co.za>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110916151044.GF11031@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2011 at 5:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Sep 16, 2011 at 05:06:03PM +0200, Henti Smith wrote:
>> On Fri, Sep 16, 2011 at 4:49 PM, Leonidas Spyropoulos
>> <artafinde@gmail.com> wrote:
>> > On Sep 16, 2011 1:25 PM, "Henti Smith" <henti@geekware.co.za> wrot=
e:
>> >> This is likely a newbie question, but I just need to confirm. If =
you
>> >> have 3 x 100GB drives in RAID0 and one drive dies this will resul=
t in
>> >> total data loss correct?
>> >>
>> > Yes the data are lost. Read more on how raid 0 works.
>>
>> I have read on how raid 0 works, I was merely asking about the
>> implementation of raid0 on btrfs.
>>
>> >> Is there no way to loose only the data that resides (even partly)=
 on
>> >> the missing drive but retain the rest of the data ?
>>
>> This is the more pertinent question, which it seem btrfs can't do cu=
rrently.
>
> =A0 btrfs stripes its RAID-0 data across all available disks, so you'=
d
> lose approximately 1/3 of the data for each file. In some cases, you
> might get lucky and have a small file that resides entirely on the tw=
o
> undamaged disks. In that case, it *might* be possible to recover your
> data, but I think in general the amount of effort involved to get tha=
t
> degree of recovery is probably far outweighted by the use of your
> backups to restore all of the missing data...
>
> =A0 Hugo.

Hi Hugo, Leonidas, everybody

Sorry to keep this going.

I've read some more on btrfs and one of the features listed as planned
is "Object-level RAID"
What will be the functional advantages of this as opposed to
filesystem level RAID.

Would this not be the place to possibly add features to allow recovery
of raid0 on an object level when a disk in the pool is lost, rather
than loosing all data ?

Henti
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
