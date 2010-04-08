From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs Bug?
Date: Thu, 8 Apr 2010 10:04:50 -0400
Message-ID: <20100408140450.GG1400@think>
References: <20100406.100812.1985.1@webmail22.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "yoosty69@netzero.com" <yoosty69@netzero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100406.100812.1985.1@webmail22.vgs.untd.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 06, 2010 at 05:08:12PM +0000, yoosty69@netzero.com wrote:
> Background:
> Was checking E-mail and browsing the internet when suddenly Pidgin crashed out. I thought that was pretty weird so I went to go re-start Pidgin when I noticed the machine hang really hard for about 30 seconds. The machine finally came back and that's when I noticed that my E-mail client (Claws Mail) had stopped responding. I 'touch'ed a file in my home dir and that was fine, but then I went to md5sum a large file and it came back with an I/O error. I ran dmesg and found that there had been a kernel dump (or whatever the proper term is) related to BTRFS. I went to shut down my programs gracefully and do a reboot, unfortunately none of my programs (FF, Pidgin, Claws-Mail, one or two others) wanted to respond so I just used the power-button.
> 
> I switched my Intel X-25M (2nd gen, latest FW as of about a month ago) to a different SATA cable and on a different port on the motherboard (Supermicro C2SBX) to see if there was some sort of hardware problem there. I booted again into Gentoo and the boot failed (I'm guessing it failed after trying to mount the root partition as RO the first time).
> 
> I booted in to System Rescue CD 1.5.1 and tried to mount the partition and mount returned with a SegFault and dmesg spit out the following:
> 
> [code]
> 
> [   75.218065] device label root devid 1 transid 4446 /dev/sda3
> [   75.225843] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1
> [   75.226049] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1
> [   75.226238] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1

Ok, this checksum verify failed means the block was corrupted.  Do you
still have this image?  We can pull the data off that one block and see
what was really there.

The crc errors are most likely from an error on the drive.  But I can
help you pull the data off if you haven't already reformatted.

-chris
