From: Asdo <asdo@shiftmail.org>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 16:59:21 +0100
Message-ID: <4B991359.3040002@shiftmail.org>
References: <4B97F7CE.4030405@bobich.net>
 <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com>
 <4B9829B1.1020706@bobich.net> <20100311073853.GA26129@attic.humilis.net>
 <f8e55948796fc6d3de67e18eb3b06807@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <f8e55948796fc6d3de67e18eb3b06807@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

Gordan Bobic wrote:
>> TRIM lets the OS tell the disk which blocks are not in use anymore, and
>> thus don't have to be copied during a rewrite of the blocks.
>> Wear-leveling is the SSD making sure all blocks are more or less equally
>> written to avoid continuous load on the same blocks.
>>     
>
> And thus it is impossible to do wear leveling when all blocks have been
> written to once without TRIM. So I'd say that in the long term, without
> TRIM there is no wear leveling. That makes them pretty related.
>   
I'm no expert of SSDs, however

1- I think the SSD would rewrite once-written blocks to other locations, 
so to reuse the same physical blocks for wear levelling. The 
written-once blocks are very good candidates because their write-count 
is "1"

2- I think SSDs show you a smaller usable size than what they physically 
have. In this way they always have some more blocks for moving data to, 
so to free blocks which have a low write-count.

3- If you think #2 is not enough you can leave part of the SSD disk 
unused, by leaving unused space after the last partition.



Actually, after considering #1 and #2, I don't think TRIM is really 
needed for SSDs, are you sure it is really needed? I think it's more a 
kind of optimization, but it needs to be very fast for it to be useful 
as an optimization, faster than an internal block rewrite by the SSD 
wear levelling, and so fast as SATA/SAS command that the computer is not 
significantly slowed down by using it. Instead IIRC I read something 
about it being slow and maybe was even requiring FUA or barrier or 
flush? I don't remember exactly.

There is one place where TRIM would be very useful though, and it's not 
for SSDs, but it's in virtualization: if the Virtual Machine frees 
space, the VM file system should use TRIM to signal to the host that 
some space is unused. The host should have a way to tell its filesystem 
that the VM-disk-file has a new hole in that position, so that disk 
space can be freed on the host for use for another VM. This would allow 
much greater overcommit of disk spaces to virtual machines.

There's probably no need for "TRIM" support itself on the host 
filesystem, but another mechanism is needed that allows to sparsify an 
existing file creating a hole in it (which I think is not possible with 
the filesystems syscalls we have now, correct me if I'm wrong). There 
*is* need for TRIM support in the guest filesystem though.

