From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Mon, 13 Feb 2012 08:09:43 -0500
Message-ID: <20120213130943.GA1573@shiny>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
 <20120210221842.GU8384@shiny>
 <20120210233959.GV8384@shiny>
 <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: btrfs@nentwig.biz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 11, 2012 at 07:27:25AM +0100, btrfs@nentwig.biz wrote:
> 
> Quoting Chris Mason <chris.mason@oracle.com>:
> 
> >On Fri, Feb 10, 2012 at 05:18:42PM -0500, Chris Mason wrote:
> >>Ok, step one:
> >>
> >>Pull down the dangerdonteveruse branch of btrfs-progs:
> >>
> >>git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> >>dangerdonteveruse
> >>
> >>Run btrfs-debug-tree -r /dev/sda1 and send the output here please.
> >
> >Sorry, that's btrfs-debug-tree -R /dev/sda1
> 
> # ./btrfs-debug-tree -R /dev/sda1
> root tree: 10229936128 level 1
> chunk tree: 10364125184 level 1
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 10229944320 level 3
> device tree key (DEV_TREE ROOT_ITEM 0) 10192654336 level 0
> fs tree key (FS_TREE ROOT_ITEM 0) 10103791616 level 3
> checksum tree key (CSUM_TREE ROOT_ITEM 0) 10103156736 level 2
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 10027970560 level 0

Ok, I'm surprised our bad block wasn't one of the roots, we're looking
for 9872289792.

Could you please do:

btrfs-debug-tree -b 9872289792 /dev/xxx

Then please run the new fsck (without any args) on the device and send
the output here.  Before we mount with -o recovery or try to repair
things, I just want to double check where this bad block lives.

> 
> But we it is that the bootloader apparently is able to load (at
> least) the kernel (and initrd) from the partition?

The btrfs-debug-tree command above should answer this, but I'd guess
that syslinux either isn't checking the parent trans id or it just
doesn't need to read this block to find the files.  That's a good sign
;)

-chris

