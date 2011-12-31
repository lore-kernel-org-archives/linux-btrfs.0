From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 18:12:42 +0100
Message-ID: <d5b5f4fe2e07a326f88bd228290e518b.squirrel@webmail.decarpentier.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
    <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
    <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
    <CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
    <CAELiMBOzsZazJsWKA7ZqcBTF4DyrFGDo0=fdvW7X8WaaN1p7bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: "Sandra Schlichting" <littlesandra88@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAELiMBOzsZazJsWKA7ZqcBTF4DyrFGDo0=fdvW7X8WaaN1p7bw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> ... and depending on which SSD you use, it shouldn't matter. Really.
>>
>> Last time I tried with sandforce SSD + btrfs + -o discard, forcing
>> trim actually made things slower. Sandforce (and probably other modern
>> SSD) controllers can work just fine even without explicit trim fs
>> support.
>
> What command did you use to test this?
>
> I have an OCZ Agility 3 SSD, which have the latest Sandforce
> controller, so I would really like to try reproduce your test setup.

Ok, the sandforce controller makes things interesting.

First of all, sandforce controllers have a very high failure rate, so make
sure you have backups!!
Sandforce controllers also use compression and deduplication to increase
performance. Encryption will make your data incompressible and random, so
this can have a big impact on performance, depending on the
characteristics of your data.
Sandforce controllers also have life time throttling, which will throttle
writes heavily if it thinks you will wear out the  flash within the
warranty period. If you have a very heavy write workload this can be an
issue.

If you don't have a working trim it is a good idea to leave part of your
drive unused. (Make sure you either do this after a full write erase of
the drive, or do a manual trim of that area, otherwise it won't work).
This will make sure the drive has enough spare sectors to do garbage
collection and can greatly improve performance if your drive is full.

Niels


