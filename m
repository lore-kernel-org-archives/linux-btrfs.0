From: Josef Bacik <josef@redhat.com>
Subject: Re: UI issues around RAID1
Date: Mon, 16 Nov 2009 15:20:43 -0500
Message-ID: <20091116202043.GA9779@localhost.localdomain>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <adapr7ib96f.fsf@roland-alpha.cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 16, 2009 at 10:45:28AM -0800, Roland Dreier wrote:
> I've just started playing around with btrfs RAID1, and I've noticed a
> couple of what seem to be UI issues.  Suppose I do something like
> "mkfs.btrfs -d raid1 -m raid1 dev1 dev2".  I see the following minor
> usability problems:
> 
>  - Unless I'm missing something, there doesn't seem to be any way later
>    on to see that I set the data policy to raid1, except using
>    btrfs-dump-tree and checking the flags bits for the appropriate
>    group.  Which can make things confusing if I have a bunch of btrfs
>    filesystems around.
> 

You aren't missing anything, theres just nothing that spits that information out
yet.  btrfs-show would probably be a good place to do this.

>  - The free space reporting doesn't seem to take into account the fact
>    that everything is going to be mirrored; so "df" et al report the
>    size of the filesystem and free space on the new filesystem as
>    size(dev1) + size(dev2) -- if dev1 and dev2 are the same size then I
>    would assume it should really be just size(dev1) for a fully-RAID1
>    filesystem.  (Not sure in general what we should say for a
>    metadata-only mirrored filesystem, since we don't really know in
>    advance how much space we have exactly)
> 

Yeah df is just a fun ball of wax in many respects.  We don't take into account
RAID and we don't subtrace space thats strictly for metadata, so there are
several things that need to be fixed for df.  Thanks,

Josef
