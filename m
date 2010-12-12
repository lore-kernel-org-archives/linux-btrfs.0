From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: btrfs subvolume list fails to show all snapshots
Date: Sun, 12 Dec 2010 04:45:17 -0500
Message-ID: <20101212094517.GA19181@idallen.ca>
References: <20101212034339.GA26170@idallen.ca>
 <20101212081359.GA7389@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101212081359.GA7389@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Creating new snapshots from previous snapshots eventually causes "btrfs
subvolume list" to omit some of the created snapshots.  The set of
omitted snapshots changes as one creates new snapshots.

(This different bug thread was found while exploring this previous thread:
Subject: btrfs subvolume snapshot hung in btrfs_commit_transaction)

What I did:

    - take one SATA disk of size 200GB
    - create one partition (/dev/sdf1) with fdisk

    # mkfs.btrfs /dev/sdf1
    WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
    WARNING! - see http://btrfs.wiki.kernel.org before using
    fs created label (null) on /dev/sdf1
	    nodesize 4096 leafsize 4096 sectorsize 4096 size 186.31GB
    Btrfs Btrfs v0.19
    
    # mount -o noatime /dev/sdf1 /mnt/sdf1

    - set <previous> = /mnt/sdf1
    - set <current> = /mnt/sdf1/snap000001
loop: 
    # btrfs subvolume snapshot <previous> <current>
    - check to make sure "btrfs subvolume list" shows all snapshots
    - set <previous> = <current>
    - set <current> = <current>+1
    GOTO loop
      
After creating snapshot 10 from snapshot 9, snapshot 6 vanished from
the output of "btrfs subvolume list /dev/sdf1":

    # btrfs subv list /mnt/sdf1
    ID 256 top level 5 path snap000001
    ID 257 top level 5 path snap000002
    ID 258 top level 5 path snap000003
    ID 259 top level 5 path snap000004
    ID 260 top level 5 path snap000005
    ID 262 top level 5 path snap000007
    ID 263 top level 5 path snap000008
    ID 264 top level 5 path snap000009
    ID 265 top level 5 path snap000010

All the snapshots, including the missing snap 6, are still on disk:

    # ls -la /mnt/sdf1/
    total 48
    dr-xr-xr-x  1 root root  208 Dec 12 03:54 ./
    drwxr-xr-x 20 root root 4096 Dec 12 03:50 ../
    drwxr-xr-x  1 root root 3666 Dec 12 03:55 ROOT/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000001/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000002/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000003/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000004/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000005/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000006/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000007/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000008/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000009/
    dr-xr-xr-x  1 root root   28 Dec 12 03:54 snap000010/

    # du -sh /mnt/sdf1/snap0000*
    1.6G	/mnt/sdf1/snap000001
    1.6G	/mnt/sdf1/snap000002
    1.6G	/mnt/sdf1/snap000003
    1.6G	/mnt/sdf1/snap000004
    1.6G	/mnt/sdf1/snap000005
    1.6G	/mnt/sdf1/snap000006
    1.6G	/mnt/sdf1/snap000007
    1.6G	/mnt/sdf1/snap000008
    1.6G	/mnt/sdf1/snap000009
    1.6G	/mnt/sdf1/snap000010

The on-disk snapshot appears to be intact and working; it just doesn't
show up in the output of "btrfs subvolume list".

If I keep creating snapshots in the above manner, the list of missing
snapshots changes:

- after creating snap 11, no snapshots are missing from the output (!)
- after creating snap 18, snap 17 goes missing
- after creating snap 21, snaps 4 and 17 are missing
- after creating snap 22, only snap 16 is missing
- after creating snap 27, snaps 3 and 16 are missing
- after creating snap 28, only snap 15 is missing
- after creating snap 29, snaps 15 and 28 are missing
- after creating snap 32, snaps 2, 15, and 28 are missing
- after creating snap 33, snaps 14 and 27 are missing
- after creating snap 39, snaps 25 and 38 are missing
- after creating snap 49, snaps 24 and 37 are missing
...etc...

Surely something is wrong here?

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
