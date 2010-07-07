From: Chris Mason <chris.mason@oracle.com>
Subject: Re: volume broken? btrfsck fails
Date: Tue, 6 Jul 2010 20:19:30 -0400
Message-ID: <20100707001930.GI15984@think>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
 <loom.20100701T144515-658@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100701T144515-658@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 01, 2010 at 12:51:04PM +0000, Daniel Kozlowski wrote:
> Yee-Ting Li <yee379 <at> gmail.com> writes:
> 
> > 
> > Hi,
> > 
> > i think my btrfs volume is hosed.... it mounts okay, but iostat shows /dev/sdg 
> on 100% load. dmesg shows lots
> > of 'parent transid verify failed on x wanted y found z'. then after a while i 
> can't read from it (access to the
> > filesystem freezes).
> > 
> > the machine had crashed (prob from some other process), and upon reboot i've 
> been experience this problem since.
> > 
> > can anyone provide any guidance in how to proceed?
> > 
> > cheers,
> > 
> > Yee.
> 
> I am also having the same problem with a slightly different setup. In My case I 
> cannot mount the filesystem.

What is your hardware setup here?  Including write cache settings.  Did
you have craces with 2.6.35-rc1 or rc2?

> mount, btrfs-endio-met and kblockd/0 will all 
> continually run until the system freezes up and requires a power cycle. I have 
> both the kernel module and the tools checked out from git so if you have any 
> ideas on fix's I can build them and test it out. 
> 
> here is some information about my setup 
> [root@solution ~]# uname -a
> Linux solution.bcig 2.6.35-0.13.rc3.git2.fc14.x86_64 #1 SMP Mon Jun 28 19:27:35 
> UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
> [root@solution ~]# 
> 
> [root@solution ~]# btrfs-show 
> Label: store  uuid: 4ba1cc6b-e12a-454a-a064-f4019312c063
> 	Total devices 7 FS bytes used 1.15TB
> 	devid    1 size 931.51GB used 415.55GB path /dev/sdb
> 	devid    2 size 931.51GB used 518.50GB path /dev/sdc
> 	devid    3 size 931.51GB used 342.04GB path /dev/sdd
> 	devid    4 size 931.51GB used 523.54GB path /dev/sde
> 	devid    5 size 465.76GB used 402.54GB path /dev/sdf
> 	devid    6 size 465.76GB used 382.54GB path /dev/sdg
> 	devid    7 size 465.76GB used 367.54GB path /dev/sdh
> 
> Btrfs v0.19-16-g075587c-dirty
> [root@solution ~]# 
> 
> [root@solution ~]# tail  -n 12 /var/log/messages
> Jul  1 04:47:03 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: verify_parent_transid: 9244 callbacks 
> suppressed
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510
> Jul  1 04:47:08 solution kernel: parent transid verify failed on 1682196926464 
> wanted 285263 found 283510

Looks like we're looping on a single block.  What happens when you
dmesg -n1 to cut down on the console traffic?

If that doesn't help we can change it to spit a stack trace to figure
out where the looping is happening.  We should be erroring out instead
of hitting it over and over again.

-chris

