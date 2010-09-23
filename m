From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Btrfs, NFS (v3) and ESTALE
Date: Thu, 23 Sep 2010 13:28:40 +0100
Message-ID: <AANLkTin7NrR-TfitLd53--Dq-wwrVdTbC6rtVRQmqhjs@mail.gmail.com>
References: <20100923110247.GD11225@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Flynn <davidf@rd.bbc.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100923110247.GD11225@rd.bbc.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 23 September 2010 12:02, David Flynn <davidf@rd.bbc.co.uk> wrote:
> Dear all;
>
> On a cluster of ~35 machines used for batch processing, which all mou=
nt
> via NFS (v3) a BTRFS export, I am experiencing issues that are causin=
g
> NFS clients to occasionally produce Stale NFS handle errors on access=
ing
> this file system. =A0I would be interested to know if this is possibl=
y
> related to use of BTRFS, or is mere coincidence.
>
> Background:
> =A0- The NFS server is running 2.6.33, with a btrfs file system creat=
ed
> =A0 =A0under the same kernel.
>
> =A0- The file system is mounted as:
> =A0 =A0/dev/md2 /work btrfs rw,noatime,nodiratime 0 0
>
> =A0- The file system is exported as:
> =A0 =A0/work =A0 =A0 =A0 =A0 =A0 <world>(rw,wdelay,root_squash,no_sub=
tree_check)
>
> =A0- Clients are mostly 2.6.35, however, problems have also been
> =A0 =A0seen with 2.6.32.
>
> =A0- Clients mount (from /proc/mounts)
> =A0 =A0vc-fs0:/work /work nfs rw,relatime,vers=3D3,rsize=3D1048576,ws=
ize=3D1048576,namlen=3D255,hard,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=
=3Dsys,mountaddr=3D172.29.146.16,mountvers=3D3,mountport=3D51102,mountp=
roto=3Dudp,addr=3D172.29.146.16 0 0
>
> The problem manifests itself when issuing a job to the cluster, of ~1=
20
> tasks on 30 nodes. =A0We will occasionally find that a machine report=
s
> NFS stale filehandle errors when trying to stat a directory. =A0The
> directory will not have been deleted during the lifetime of the job,
> however some (eg 30) sub-directories will have been created.
>
> The erros are Usually seen from a machine that has not done any work.
>
> For example:
>
> (2.6.35:)
> vcfe0:~$ ls -l /work >/dev/null
> --launch job (doesn't do anything on vcfe, uses different nodes)--
> ... time passes (unknown how long) ...
>
> vcfe0:~$ ls -l /work >/dev/null
> ls: cannot access /work/marta-cip-test: Stale NFS file handle
> ls: cannot access /work/andrea-test-ais: Stale NFS file handle
>
> (2.6.35:)
> vc-r210-0:~$ ls -l /work >/dev/null
> vc-r210-0:~$
>
> (2.6.32:)
> b36048:~$ ls -l /work/ >/dev/null
> ls: cannot access /work/marta-cip-test: Stale NFS file handle
> ls: cannot access /work/andrea-test-ais: Stale NFS file handle
>
> Two separate machines are seeing the same stale file handles. =A0b360=
48
> hadn't even touched /work for some considerable time before doing tha=
t
> ls.
>
> performing `touch /work/andrea-test-ais' on the client will allow the
> client machine to stat the directory again, however, doing it on the
> file server does not.
>
> performing `echo 2 > /proc/sys/vm/drop_caches' on the client will
> sometimes solve the problem for that client [but not always].
>
> I've not yet found a reliable way to reproduce the problem, other tha=
n
> running large jobs (we aren't running small ones at the moment, so ca=
n't
> say if it is related to size)
>
> I would be interested to know if anyone believes this may be related =
to
> the use of btrfs, (or even a configuration / nfs cache coherency prob=
lem).
>
> Some extra anecdotal evidence:
> =A0I don't recall this being an issue before we upgraded all the comp=
ute
> =A0nodes to 2.6.35. =A0Previously they used 2.6.33, but an upgrade wa=
s
> =A0forced due to an nfs bug under high write loads. =A0However, it ma=
y be
> =A0that the nature of the jobs that we are running now has changed
> =A0slightly too.

I was experiencing a similar pattern of ESTALE issues with NFS with
2.6.33 (IIRC) and cached data on ext4, and could reproduce it from
time to time performing kernel rebuilds over NFS.

I've CC'd Trond on the full email to see if it rings a bell. The best
outcome may be if we write a micro-reproducer which exploits this race
using cached data.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
