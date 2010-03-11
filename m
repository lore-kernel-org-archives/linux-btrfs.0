From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 16:15:37 +0000
Message-ID: <66212e5fade0ce6ec9086b8b71be36fe@localhost>
References: <4B97F7CE.4030405@bobich.net> <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com> <4B9829B1.1020706@bobich.net> <20100311073853.GA26129@attic.humilis.net> <f8e55948796fc6d3de67e18eb3b06807@localhost> <4B98F350.6080804@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B98F350.6080804@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 14:42:40 +0100, Asdo <asdo@shiftmail.org> wrote:

> 1- I think the SSD would rewrite once-written blocks to other locations,

> so to reuse the same physical blocks for wear levelling. The 
> written-once blocks are very good candidates because their write-count 
> is "1"

There are likely to be millions of blocks with the same write count. How
do you pick the optimal ones?

> 2- I think SSDs show you a smaller usable size than what they physically

> have. In this way they always have some more blocks for moving data to, 
> so to free blocks which have a low write-count.

I'm pretty sure that is the case, too. However, to be able to deal with
the worst case scenario you would have to effectively double the amoutn of
flash (only expose half of it as addressable). With some corner cutting and
assumptions about file systems' block sizes (usually 4KB these days), you
can cut a corner, but that's dodgy until we get bigger hardware sectors as
standard.

> 3- If you think #2 is not enough you can leave part of the SSD disk 
> unused, by leaving unused space after the last partition.

That is true, but I'd rather apply some higher level logic to this rather
than expect the firmware do make a guess about things it has absolutely no
way of knowing for sure.

> Actually, after considering #1 and #2, I don't think TRIM is really 
> needed for SSDs, are you sure it is really needed?

I don't think there's any doubt that trim helps flash longevity.

> I think it's more a 
> kind of optimization, but it needs to be very fast for it to be useful 
> as an optimization, faster than an internal block rewrite by the SSD 
> wear levelling, and so fast as SATA/SAS command that the computer is not

> significantly slowed down by using it. Instead IIRC I read something 
> about it being slow and maybe was even requiring FUA or barrier or 
> flush? I don't remember exactly.

There is no obligation on part of the disk to do anything in response to
the trim command, IIRC. It is advisory. It doesn't have to clear the blocks
online. In fact, trim is sector based, and it is unlikely an SSD would act
until it can sensibly free an entire erase block.

> There is one place where TRIM would be very useful though, and it's not 
> for SSDs, but it's in virtualization: if the Virtual Machine frees 
> space, the VM file system should use TRIM to signal to the host that 
> some space is unused. The host should have a way to tell its filesystem 
> that the VM-disk-file has a new hole in that position, so that disk 
> space can be freed on the host for use for another VM. This would allow 
> much greater overcommit of disk spaces to virtual machines.

Indeed, I brought this very point up on the KVM mailing list a while back.

Gordan
