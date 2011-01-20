From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: btrfs subvolume list fails to show all snapshots
Date: Thu, 20 Jan 2011 18:01:27 -0500
Message-ID: <20110120230127.GB4161@idallen.ca>
References: <20101212034339.GA26170@idallen.ca>
 <20101212081359.GA7389@idallen.ca>
 <20101212094517.GA19181@idallen.ca>
 <4D05DD9A.2060206@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05DD9A.2060206@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Still getting "btrfs subvolume list" errors with this source:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

I create ten snapshots, and after creating the tenth one, the sixth one
disappears from "btrfs subvolume list":

# btrfs subvolume list /mnt/sdb1
ID 256 top level 5 path snap000001
ID 257 top level 5 path snap000002
ID 258 top level 5 path snap000003
ID 259 top level 5 path snap000004
ID 260 top level 5 path snap000005
ID 262 top level 5 path snap000007
ID 263 top level 5 path snap000008
ID 264 top level 5 path snap000009
ID 265 top level 5 path snap000010

# ls -lt /mnt/sdb1
total 48
drwxr-xr-x 1 root root   42 Jan 20 17:55 ROOT/
dr-xr-xr-x 1 root root  208 Jan 20 17:55 ./
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000001/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000002/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000003/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000004/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000005/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000006/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000007/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000008/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000009/
dr-xr-xr-x 1 root root   28 Jan 20 17:55 snap000010/
drwxr-xr-x 4 root root 4096 Jan 20 15:30 ../


On Mon, Dec 13, 2010 at 04:47:22PM +0800, Li Zefan wrote:
> > After creating snapshot 10 from snapshot 9, snapshot 6 vanished from
> > the output of "btrfs subvolume list /dev/sdf1":
> > 
> >     # btrfs subv list /mnt/sdf1
> >     ID 256 top level 5 path snap000001
> >     ID 257 top level 5 path snap000002
> >     ID 258 top level 5 path snap000003
> >     ID 259 top level 5 path snap000004
> >     ID 260 top level 5 path snap000005
> >     ID 262 top level 5 path snap000007
> >     ID 263 top level 5 path snap000008
> >     ID 264 top level 5 path snap000009
> >     ID 265 top level 5 path snap000010
> > 
> ...
> > Surely something is wrong here?
> > 
> 
> Right, there's something wrong and I've figured it out.
> Will send out a fix soon.
> Thanks for the report!

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
