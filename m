From: Fred van Zwieten <fvzwieten@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Tue, 31 Aug 2010 20:44:13 +0200
Message-ID: <AANLkTimXSUqsOVj_UQEut4E1w3Nj-3vgoHKs-7JUHxaT@mail.gmail.com>
References: <29385727.6.1283191163871.JavaMail.root@zimbra>
	<4C7BF51B.2070201@noir.com>
	<20100831063031.GE29552@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "K. Richard Pixley" <rich@noir.com>,
	Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100831063031.GE29552@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Thinking about this a bit more, would a setup with btrfs on top of
DRBD be a setup that comes in the neighboorhood of what SnapMirror
provides? DRBD does replication at the blocklevel, without any notion
of a filesystem on top of it (as I understand this). So, if I make a
snapshot on a DRBD'ed btrfs filesystem, this snapshot would also get
replicated at the DRBD level. Provided I put the DB in a consisted
state before making the snap, I have a remote consistent copy of this
DB. This copy can be used as a failover target or as a basis for
restore.

Am I correct?


On Tue, Aug 31, 2010 at 8:30 AM, Simon Kirby <sim@hostway.ca> wrote:
> On Mon, Aug 30, 2010 at 11:14:51AM -0700, K. Richard Pixley wrote:
>
>> =C2=A0On 20100830 10:59, Roy Sigurd Karlsbakk wrote:
>>>> I think drbd does precisely what you want.
>>>>
>>>> It's not useful for fault tolerance, nor for load balancing, but i=
t
>>>> will
>>>> produce a remote block copy that can be used as a sort of "hot
>>>> backup".
>>> drbd with heartbeat/pacemaker can provide fault tolerance...
>> I think that's a matter of semantics.
>>
>> Once you've failed over from the primary system to the secondary,
>> changes to your block device are terminal. =C2=A0It's not easy to pr=
oduce a
>> system which can manage those changes and "heal" in the sense of
>> allowing the primary system to return to service. =C2=A0In effect, r=
eturning
>> the primary system to service requires taking both systems down and
>> copying the block device from the secondary back to the first.
>
> This is totally incorrect. =C2=A0DRBD replicates in both directions q=
uite
> well, in fact. =C2=A0I've been using it on about 60 machines for many=
 years,
> and I have never had to do what you mention.
>
> What it does not help with is avoiding corruption that occurs above t=
he
> block layer; eg, if your file system or your database on top of it ba=
rfs,
> there is no other "good copy". =C2=A0fsck or repair is still required=
 in these
> cases. =C2=A0It is just like local RAID 1 in this respect -- you stil=
l need a
> backup and/or copy at the file level, which is closer to what is need=
ed
> here.
>
> Simon-
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
