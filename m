From: David McBride <dwm@doc.ic.ac.uk>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 05 Sep 2011 15:17:23 +0100
Message-ID: <4E64D9F3.9010201@doc.ic.ac.uk>
References: <4E64D3D5.7020407@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64D3D5.7020407@petaramesh.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/11 14:51, =EF=BF=BD wrote:

> Given 4 laptops, the most powerful of which was running BTRFS and the=
 others
> ext3 or ext4, all machines running Ubuntu 11.04 Natty 32-bit with a s=
tock
> Ubuntu 2.6.38-11 kernel, all machines were given the following FS-int=
ensive
> task :

(dpkg-intensive workload)

> All 3 ext3 /  ext4 machines took between 60 and 90 minutes to complet=
e their
> upgrade.
>=20
> BTRFS machine took 20 HOURS so far, still counting (ETA 15 minutes le=
ft).
>=20
> Wow. Impressive.

I see similar behaviour on a single-disk workstation. This is a consequ=
ence of
dpkg's heavy use of fsync() to ensure that changes to the filesystem ar=
e done
safely, to try to ensure that a sudden crash or power interruption does=
n't
leave the machine in an inconsistent or unrecoverable state.

(You can see that btrfs performs speedily if fsync is disabled via, for
example, `eatmydata`.  Which is not a production-worthy workaround for =
the
majority of cases, but usefully highlights what's going wrong.)

See also:
  https://bugs.launchpad.net/ubuntu/+source/dpkg/+bug/607632
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D635993

Now, I don't know why btrfs is particularly slow with a (relatively?)
fsync-heavy workload, though I do note that a commit went into 3.0 that
improved some fsync workloads; see commit:
8e531cdfeb75269c6c5aae33651cca39707848da

However, in my own testing, it doesn't seem to have improved matters
significantly.

There were also a number of fsync-related improvements made in 2.6.32; =
perhaps
there have been regressions since then?

It seems clear that the dpkg developers consider this to be reasonable
behaviour on their part; is there any scope for improvements to be made=
 to
btrfs to cope better with this kind of workload?  Or is this an unavoid=
able
property of the datastructures it's using?

Cheers,
David
--=20
David McBride <dwm@doc.ic.ac.uk>
Department of Computing, Imperial College, London
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
