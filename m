From: David Nicol <davidnicol@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 6 Sep 2010 16:50:39 -0500
Message-ID: <AANLkTikze-2DsoMb6h-hvz4H8CPpHgxUqx7vCaOyV7+p@mail.gmail.com>
References: <29385727.6.1283191163871.JavaMail.root@zimbra> <4C7BF51B.2070201@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C7BF51B.2070201@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 30, 2010 at 1:14 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> In terms of fault tolerance, I'd call this a tolerance of about a hal=
f a
> fault since the system cannot return to it's initial configuration wi=
thout
> breaking continuity of service.
>
> And there really isn't any way to extend this. It's not fault toleran=
ce in
> the virtual synchrony sense where there can be a pool of N machines, =
all
> symmetric, which can tolerate N - 1 failures and produce continuing s=
ervice
> throughout.
>
> It's also not load balanced in the virtual synchrony sense where N ma=
chines
> can all be in service concurrently and the service can tolerate N - 1
> failures, albeit at degraded performance. =C2=A0Or in the sense where=
 failed
> servers can return to the group dynamically.
>
> It's not sufficient for any application in which I've ever sought fau=
lt
> tolerance. =C2=A0If it's sufficient for you, that's great. =C2=A0But =
my definition of
> "fault tolerance" requires that the system be capable of returning to=
 it's
> initial state without loss of service. =C2=A0The heartbeat approach w=
ith single
> failover can't do that.
>
> --rich - who is likely now off topic.


Only off-topic if BTRFS isn't ever going to ooze into the space
currently occupied by the likes of

http://en.wikipedia.org/wiki/Global_File_System

that is, file systems that have multiple nodes simultaneously
accessing block devices and tolerating faults.

There's more to HA than the file system though; well, depending on
what kinds of faults you're worried about
mitigating the risk of.

I imagine (very likely now pollyanna) that  refactoring GFS's lock
discipline to work above BTRFS's on-disk format might be a worthwhile
endeavour, or at least something to think about.  Reimplementing the
locking over BTRFS might be a shorter way there.

I'm for modular extent provisioning, which in theory could allow all
kinds of unnecessarily wasted CPU cycles, as extents get managed by
user-space daemons allocating them out of whatever file systems they
happen to be running on.


--=20
"Elevator Inspection Certificate is on file in the Maintenance Office"
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
