From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs subvolume list fails to show all snapshots
Date: Mon, 13 Dec 2010 16:47:22 +0800
Message-ID: <4D05DD9A.2060206@cn.fujitsu.com>
References: <20101212034339.GA26170@idallen.ca> <20101212081359.GA7389@idallen.ca> <20101212094517.GA19181@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101212094517.GA19181@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

> After creating snapshot 10 from snapshot 9, snapshot 6 vanished from
> the output of "btrfs subvolume list /dev/sdf1":
> 
>     # btrfs subv list /mnt/sdf1
>     ID 256 top level 5 path snap000001
>     ID 257 top level 5 path snap000002
>     ID 258 top level 5 path snap000003
>     ID 259 top level 5 path snap000004
>     ID 260 top level 5 path snap000005
>     ID 262 top level 5 path snap000007
>     ID 263 top level 5 path snap000008
>     ID 264 top level 5 path snap000009
>     ID 265 top level 5 path snap000010
> 
...
> Surely something is wrong here?
> 

Right, there's something wrong and I've figured it out.
Will send out a fix soon.

Thanks for the report!
