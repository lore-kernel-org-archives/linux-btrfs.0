From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sun, 1 Jan 2012 16:22:04 +0100
Message-ID: <a251c794abe4baf796f661aa57c7dad3.squirrel@webmail.decarpentier.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
    <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
    <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
    <CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
    <CAELiMBOzsZazJsWKA7ZqcBTF4DyrFGDo0=fdvW7X8WaaN1p7bw@mail.gmail.com>
    <d5b5f4fe2e07a326f88bd228290e518b.squirrel@webmail.decarpentier.com>
    <CAG1y0sf4=p9+V8cZ+OGnrhkxmPgBhtECf==vvR=VSaY7JuX8JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "Sandra Schlichting" <littlesandra88@gmail.com>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sf4=p9+V8cZ+OGnrhkxmPgBhtECf==vvR=VSaY7JuX8JQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On Sun, Jan 1, 2012 at 12:12 AM, Niels de Carpentier
> <niels@decarpentier.com> wrote:
>>>> ... and depending on which SSD you use, it shouldn't matter. Reall=
y.
>>>>
>>>> Last time I tried with sandforce SSD + btrfs + -o discard, forcing
>>>> trim actually made things slower. Sandforce (and probably other mo=
dern
>>>> SSD) controllers can work just fine even without explicit trim fs
>>>> support.
>>>
>>> What command did you use to test this?
>
> Normal usage, and some random i/o test tool like fio.

Some interesting information here"

http://people.redhat.com/jmoyer/discard/ext4_batched_discard/ext4_disca=
rd.html

and here:

http://purdea.ro/projects/trim_perf/

Depending on the vendor, discard will generally be slower, but can have=
 a
huge performance impact. TRIM is not queueable, so it will force a queu=
e
flush and will block all following commands. The OCZ Agility 3 seems
especially slow, were a discard command will take at least 10ms!

>>> I have an OCZ Agility 3 SSD, which have the latest Sandforce
>>> controller, so I would really like to try reproduce your test setup=
=2E
>
> Yours should be newer. Mine is somewhat-old corsair force 60 GB with
> btrfs on top. When I activated -o discard, it actually become slower.
> Also, when I used fstrim, the IOPS were capped at 100, so probably th=
e
> slowdown is because of that (i.e. IOPS-limit of TRIM somewhere,
> possibly the controller)

See above, do NOT turn on filesytem discard support on a OCZ agility 3,
the performance impact is huge! You're better of scheduling a daily
swiper.sh or fstrim run, with the advantage that it will probably also
work if intermediate layers don't support discard.

>>
>> Ok, the sandforce controller makes things interesting.
>>
>> First of all, sandforce controllers have a very high failure rate, s=
o
>> make
>> sure you have backups!!
>
> Yes, but even knowing that I can't imagine going back to HDD for this
> particular system. It'd be too slow to bear :P

Ik know :) However, considering OCZ sandforce controllers have a failur=
e
rate of 5-10%, compared to intel with 0.5%, you might want to consider
switching to a more reliable one and selling the OCZ. I any case make v=
ery
sure you make frequent backups and that they are working!
The sandforce controllers look nice on paper, but the unreliabilty,
disappointing speeds for compressed data, lifetime write throtteling an=
d
extremely slow trim performance make then one of the worst choices in
practice. The crucial M4 and Samsung 830 are very good in the same pric=
e
class, the intel 320 is the most reliable and a bit cheaper, but slower
and SATA300. The kingston V100+ is a reasonable budget choice. My advic=
e
would be to avoid ocz/sandforce at all costs, you can easily find lots =
of
horror stories with google or newegg product reviews.

>> Sandforce controllers also use compression and deduplication to incr=
ease
>> performance. Encryption will make your data incompressible and rando=
m,
>> so
>> this can have a big impact on performance, depending on the
>> characteristics of your data.
>
> In my case I use compress=3Dlzo, so it shouldn't be compressible by t=
he
> controllers.

Yes, but dedup might still allow the drive to have more empty space to =
do
wear leveling/garbage collection, especially if you don't use trim.
>
>> Sandforce controllers also have life time throttling, which will
>> throttle
>> writes heavily if it thinks you will wear out the =A0flash within th=
e
>> warranty period. If you have a very heavy write workload this can be=
 an
>> issue.
>
> That's new. Is there a link/reference for that?

http://www.xtremesystems.org/forums/showthread.php?272545-Sandforce-Lif=
e-Time-Throttling
http://www.xtremesystems.org/forums/showthread.php?271063-SSD-Write-End=
urance-25nm-Vs-34nm

The endurance test thread is pretty cool, as it shows that SSD's can
handle much more writes then the manufacturer spec (Except for the
sandforce ones, which limit write speeds until it is impossible to exce=
ed
the manufacturer spec during the waranty period.)

> True. But on my last test I can't get fstrim to trim everything. It
> could only trim about 2GB out of 12GB free space.

Did you try wiper.sh? That should work better as it allocates all free
space and then runs trim on it. It might still miss some areas, but sho=
uld
be much better then 2 out of 12!

Niels

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
