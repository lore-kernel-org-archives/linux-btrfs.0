From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Cloning a Btrfs partition
Date: Tue, 13 Dec 2011 23:06:26 +0100
Message-ID: <1534685.yyhN3sYL3e@venice>
References: <dc6ccf7d-261b-487c-966f-a7bcdd0439cc@mail.placs.net>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: BJ Quinn <bj@placs.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <dc6ccf7d-261b-487c-966f-a7bcdd0439cc@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 12 December, 2011 15:41:29 you wrote:
> >You can't change the uuid of an existing btrfs partition. Well, you
> >can, but you have to rewrite all the metadata blocks.
> 
> Is there a tool that would allow me to rewrite all the metadata blocks with
> a new UUID?  At this point, it can't possibly take longer than the way I'm
> trying to do it now...
> 
> Someone once said "Resetting the UUID on btrfs isn't a quick-and-easy thing
> - you have to walk the entire tree and change every object. We've got a
> bad-hack in meego that uses btrfs-debug-tree and changes the UUID while it
> runs the entire tree, but it's ugly as hell."

I am looking for that. btrfs-debug-tree is capable to dump every leaf and 
every node logical address.

To change the UUID of a btrfs filesystem

On every leaf/node we should
- update the FSID						(a)
- update the chunk_uuid [*]
- update the checksum

for the "dev_item" items we should update the
- device UUID							(b)
- FSID									(see 'a')

for the "chunk_item" items we should update the
- device UUID of every stripe			(b)

for every superblock (three for device), we should update:
- FSID									(see 'a')
- device uuid							(see 'b')
- for every "system chunk" items contained in the superblock we should update:
	- device UUID of every stripe			(b)
- update the checksum

The most complex part is to map the logical address to the physical device. 

In the next days I will tray (if I had enough time) to make something...




> 
> Ok, I'll take the bad-hack.  How would I actually go about using said
> bad-hack?
> 
> -BJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
