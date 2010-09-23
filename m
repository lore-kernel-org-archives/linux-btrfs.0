From: David Flynn <davidf@rd.bbc.co.uk>
Subject: Btrfs, NFS (v3) and ESTALE
Date: Thu, 23 Sep 2010 11:02:47 +0000
Message-ID: <20100923110247.GD11225@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davidf@rd.bbc.co.uk
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear all;

On a cluster of ~35 machines used for batch processing, which all mount
via NFS (v3) a BTRFS export, I am experiencing issues that are causing
NFS clients to occasionally produce Stale NFS handle errors on accessing
this file system.  I would be interested to know if this is possibly
related to use of BTRFS, or is mere coincidence.

Background:
  - The NFS server is running 2.6.33, with a btrfs file system created
    under the same kernel.

  - The file system is mounted as:
    /dev/md2 /work btrfs rw,noatime,nodiratime 0 0

  - The file system is exported as:
    /work           <world>(rw,wdelay,root_squash,no_subtree_check)

  - Clients are mostly 2.6.35, however, problems have also been
    seen with 2.6.32.

  - Clients mount (from /proc/mounts)
    vc-fs0:/work /work nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.29.146.16,mountvers=3,mountport=51102,mountproto=udp,addr=172.29.146.16 0 0

The problem manifests itself when issuing a job to the cluster, of ~120
tasks on 30 nodes.  We will occasionally find that a machine reports
NFS stale filehandle errors when trying to stat a directory.  The
directory will not have been deleted during the lifetime of the job,
however some (eg 30) sub-directories will have been created.

The erros are Usually seen from a machine that has not done any work.

For example:

(2.6.35:)
vcfe0:~$ ls -l /work >/dev/null
--launch job (doesn't do anything on vcfe, uses different nodes)--
... time passes (unknown how long) ...

vcfe0:~$ ls -l /work >/dev/null
ls: cannot access /work/marta-cip-test: Stale NFS file handle
ls: cannot access /work/andrea-test-ais: Stale NFS file handle

(2.6.35:)
vc-r210-0:~$ ls -l /work >/dev/null
vc-r210-0:~$

(2.6.32:)
b36048:~$ ls -l /work/ >/dev/null
ls: cannot access /work/marta-cip-test: Stale NFS file handle
ls: cannot access /work/andrea-test-ais: Stale NFS file handle

Two separate machines are seeing the same stale file handles.  b36048
hadn't even touched /work for some considerable time before doing that
ls.

performing `touch /work/andrea-test-ais' on the client will allow the
client machine to stat the directory again, however, doing it on the
file server does not.

performing `echo 2 > /proc/sys/vm/drop_caches' on the client will
sometimes solve the problem for that client [but not always].

I've not yet found a reliable way to reproduce the problem, other than
running large jobs (we aren't running small ones at the moment, so can't
say if it is related to size)

I would be interested to know if anyone believes this may be related to
the use of btrfs, (or even a configuration / nfs cache coherency problem).

Some extra anecdotal evidence:
  I don't recall this being an issue before we upgraded all the compute
  nodes to 2.6.35.  Previously they used 2.6.33, but an upgrade was
  forced due to an nfs bug under high write loads.  However, it may be
  that the nature of the jobs that we are running now has changed
  slightly too.

Kind regards,

..david
