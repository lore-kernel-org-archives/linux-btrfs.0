From: David Flynn <davidf@rd.bbc.co.uk>
Subject: Re: Btrfs, NFS (v3) and ESTALE
Date: Thu, 4 Nov 2010 22:40:03 +0000
Message-ID: <20101104224003.GL12804@rd.bbc.co.uk>
References: <20100923110247.GD11225@rd.bbc.co.uk> <AANLkTin7NrR-TfitLd53--Dq-wwrVdTbC6rtVRQmqhjs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Flynn <davidf@rd.bbc.co.uk>, linux-btrfs@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin7NrR-TfitLd53--Dq-wwrVdTbC6rtVRQmqhjs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Daniel J Blueman (daniel.blueman@gmail.com) wrote:
> I was experiencing a similar pattern of ESTALE issues with NFS with
> 2.6.33 (IIRC) and cached data on ext4, and could reproduce it from
> time to time performing kernel rebuilds over NFS.
> 
> I've CC'd Trond on the full email to see if it rings a bell. The best
> outcome may be if we write a micro-reproducer which exploits this race
> using cached data.

I've recently seen quite a concrete case, which may be interesting:

NB, this is not an exact transcript

## step1: build a binary to use (out of tree build, touches: depends
##        files, object files, binaries)
vcfe:some/dir/bin$ make
## step2: launch a job on the cluster that uses the binaries in dir/bin
##        but does not touch any other files in dir/bin
vcfe:some/dir$ sbatch -N4 my_job.sh
## step3: let time pass (job completed, came back next day)
##
vcfe:some/dir$ ls -l bin
< many stale filehandle errors >

In actual fact, steps 1 and 2 were repeated several times (happened to be
bisecting something) with out issue, then the following day step 3
revealed a problem.

Now all writes to dir/bin occurred on vcfe, other computers only accessed
it for the binary.  Other computers will have created extra directories
in "some/dir/".

stale filehandle errors were resolved by:
  echo 2 > /proc/sys/vm/drop_caches

A quick summary of the setup:
 - nfs client was 2.6.35, mounting with nfsv3
 - nfs server was 2.6.33, exporting a btrfs filesystem (noatime,nodiratime)

I'd be very interested if anyone has any further thoughts on the issue.

Kind regards,

..david
