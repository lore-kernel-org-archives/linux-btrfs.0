From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Thu, 16 Dec 2010 09:41:50 +0100
Message-ID: <037hfaxg6p.fsf@msgid.viggen.net>
References: <4D08E76B.40400@logtenberg.eu> <1292439708-sup-2951@think>
	<4D091387.9050905@logtenberg.eu> <1292440771-sup-9278@think>
	<4D091679.80706@logtenberg.eu> <1292441925-sup-1105@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Chris Mason]=20

> Excerpts from Erik Logtenberg's message of 2010-12-15 14:26:49 -0500:
>>=20
>> The use case is a filesystem used for backups, which are rsynced
>> nightly, after which a new snapshot is made. After something like 45
>> days, the old snapshots are removed. I am assuming that this way, af=
ter
>> 45 days all files will be compressed naturally, but this is only
>> beneficial if snapshots still fully work. If instead it results in
>> storing the compressed form of every file 45 times on disk, then it
>> won't help much.
>
> Yes, you'll end up with a fully compressed and fully shared setup aft=
er
> 45 days.

How would that happen?  Rsync only rewrites files if they have changed.
If compression happens only when a file is written to, any files that
were written uncompressed will remain uncompressed until they change on
the source filesystem (triggering a rewrite on the backup drive).

Unless there's some magic I'm missing, expiring the old snapshots from
before -o compress won't really affect anything.

=D8ystein
--=20
Outgoing mail is certified Virus Free.
=2E.of course, the virus would tell you the same thing..

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
