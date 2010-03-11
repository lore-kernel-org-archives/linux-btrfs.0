From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:59:32 +0000
Message-ID: <f8e55948796fc6d3de67e18eb3b06807@localhost>
References: <4B97F7CE.4030405@bobich.net> <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com> <4B9829B1.1020706@bobich.net> <20100311073853.GA26129@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311073853.GA26129@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 08:38:53 +0100, Sander <sander@humilis.net> wrote:
>> >>Are there options available comparable to ext2/ext3 to help reduce
>> >>wear and improve performance?
> 
> With SSDs you don't have to worry about wear.

And if you believe that you clearly swallowed the marketing spiel hook
line and sinker without enough real world exprience to show you otherwise.
But I'm not going to go off on a tangent now enumerating various victories
of marketing over mathematics and empirical evidence relating to currently
popular technologies.

In short - I have several dead SSDs of various denominations that
demonstrate otherwise - and all within their warranty period, and not
having been used in pathologically write-heavy environments. You do have to
worry about wear. Operations that increase wear also reduce speed (erasing
a block is slow, and if the disk is fully tainted you cannot write without
erasing), so you doubly have to worry about it.

Also remember that hardware sectors are 512 bytes, and FS blocks tend to
be 4096 bytes. It is thus entirely plausible that if you aren't careful
you'll end up with blocks straddling two erase block boundaries. If that
happens, you'll make wear twice as bad because you are facing a situation
where you may need to erase and write two blocks rather than one. Half the
performance, twice the wear.

>> And while I appreciate hopeful remarks along the lines of "I think
>> you'll get more out of btrfs", I am really after specifics of what
>> the ssd mount option does, and what features comparable to the
>> optimizations that can be done with ext2/3/4 (e.g. the mentioned
>> stripe-width option) are available to get the best possible
>> alignment of data and metadata to increase both performance and life
>> expectancy of a SSD.
> 
> Alignment is about the partition, not the fs, and thus taken care of
> with fdisk and the like.
> 
> If you don't create a partition, the fs is aligned with the SSD.

I'm talking about internal FS data structures, not the partition
alignment.

>> Also, for drives that don't support TRIM, is there a way to make the
>> FS apply aggressive re-use of erased space (in order to help the
>> drive's internal wear-leveling)?
> 
> TRIM has nothing to do with wear-leveling (although it helps reducing
> wear).

That's self contradictory. If it helps reduce wear it has something to do
with wear leveling.

> TRIM lets the OS tell the disk which blocks are not in use anymore, and
> thus don't have to be copied during a rewrite of the blocks.
> Wear-leveling is the SSD making sure all blocks are more or less equally
> written to avoid continuous load on the same blocks.

And thus it is impossible to do wear leveling when all blocks have been
written to once without TRIM. So I'd say that in the long term, without
TRIM there is no wear leveling. That makes them pretty related.

So considering that there are various nuggets of opinion floating around
(correct or otherwise) saying that ext4 has support for TRIM, I'd like to
know whether there similar support in BTRFS at the moment?

Gordan
