From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Encryption implementation like ZFS?
Date: Sun, 1 Jan 2012 06:04:20 +0700
Message-ID: <CAG1y0sf4=p9+V8cZ+OGnrhkxmPgBhtECf==vvR=VSaY7JuX8JQ@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
	<CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
	<CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
	<CAELiMBOzsZazJsWKA7ZqcBTF4DyrFGDo0=fdvW7X8WaaN1p7bw@mail.gmail.com>
	<d5b5f4fe2e07a326f88bd228290e518b.squirrel@webmail.decarpentier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sandra Schlichting <littlesandra88@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Niels de Carpentier <niels@decarpentier.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d5b5f4fe2e07a326f88bd228290e518b.squirrel@webmail.decarpentier.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 1, 2012 at 12:12 AM, Niels de Carpentier
<niels@decarpentier.com> wrote:
>>> ... and depending on which SSD you use, it shouldn't matter. Really=
=2E
>>>
>>> Last time I tried with sandforce SSD + btrfs + -o discard, forcing
>>> trim actually made things slower. Sandforce (and probably other mod=
ern
>>> SSD) controllers can work just fine even without explicit trim fs
>>> support.
>>
>> What command did you use to test this?

Normal usage, and some random i/o test tool like fio.

>>
>> I have an OCZ Agility 3 SSD, which have the latest Sandforce
>> controller, so I would really like to try reproduce your test setup.

Yours should be newer. Mine is somewhat-old corsair force 60 GB with
btrfs on top. When I activated -o discard, it actually become slower.
Also, when I used fstrim, the IOPS were capped at 100, so probably the
slowdown is because of that (i.e. IOPS-limit of TRIM somewhere,
possibly the controller)

>
> Ok, the sandforce controller makes things interesting.
>
> First of all, sandforce controllers have a very high failure rate, so=
 make
> sure you have backups!!

Yes, but even knowing that I can't imagine going back to HDD for this
particular system. It'd be too slow to bear :P

> Sandforce controllers also use compression and deduplication to incre=
ase
> performance. Encryption will make your data incompressible and random=
, so
> this can have a big impact on performance, depending on the
> characteristics of your data.

In my case I use compress=3Dlzo, so it shouldn't be compressible by the
controllers.

> Sandforce controllers also have life time throttling, which will thro=
ttle
> writes heavily if it thinks you will wear out the =A0flash within the
> warranty period. If you have a very heavy write workload this can be =
an
> issue.

That's new. Is there a link/reference for that?

>
> If you don't have a working trim it is a good idea to leave part of y=
our
> drive unused. (Make sure you either do this after a full write erase =
of
> the drive, or do a manual trim of that area, otherwise it won't work)=
=2E
> This will make sure the drive has enough spare sectors to do garbage
> collection and can greatly improve performance if your drive is full.

True. But on my last test I can't get fstrim to trim everything. It
could only trim about 2GB out of 12GB free space.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
