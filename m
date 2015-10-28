Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42713 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965564AbbJ1NKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 09:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZrQUM-0004TV-W0
	for linux-btrfs@vger.kernel.org; Wed, 28 Oct 2015 14:10:03 +0100
Received: from ip68-5-198-206.oc.oc.cox.net ([68.5.198.206])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 14:10:02 +0100
Received: from Cheshireccat by ip68-5-198-206.oc.oc.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 14:10:02 +0100
To: linux-btrfs@vger.kernel.org
From: JDAIII <Cheshireccat@gmail.com>
Subject: Re: btrfs-undelete shell-script
Date: Wed, 28 Oct 2015 06:06:35 +0000 (UTC)
Message-ID: <loom.20151028T070456-61@post.gmane.org>
References: <1842933.L15n886rVc@queen>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


JÃ¶rg Walter <info <at> syntax-k.de> 
writes:

> 
> Hi,
> 
> I tried to recover an accidentally 
deleted text file from a btrfs volume 
using 
> the trusty old 'grep --text -C 500' 
method and failed, since the filesystem 
was 
> compressed. So I wrote a shell script 
that uses btrfs-progs for a proper 
> undelete functionality.
> 
> Attached is the script that implements a 
working btrfs-undelete using the find-
> root and restore tools from btrfs-progs. 
It is fairly complete and solid and 
> it even has some command  line help. It 
needs bash and common unix utilities 
> (sed, grep, wc, dirname, sort). I have 
successfully used it to recover a 
> couple of files I deleted accidentally 
and was able to recover 2/3 of them just 
> fine. The rest was zero-sized, I assume 
that's because the file blocks have 
> already been reused.
> 
> If you like it, feel free to add it to 
btrfs-progs. I've chosen GPLv2 or later 
> as license, as that's what btrfs-progs 
seems to use.
> 
> Please CC me on replies, I am not 
subscribed (and don't intend to).
> 

Hi all, new to btrfs and have an issue. 
Thought I'd hit you folks up for some 
assistance.

First things first. I have exhausted 
Google and tried the btrfs-undelete 
script. I've had no luck recovering my 
directory. I need to recover it asap as 
important files are on the drive also that 
we need and I have it unmounted until we 
figure this out.

I've tried a few blocks and I get the same 
error here.

I've tried btrfs restore as you see here.

$ sudo btrfs restore /dev/sde /media -v -i 
-t 1060780900352
parent transid verify failed on 
1060780900352 wanted 39805 found 39797
parent transid verify failed on 
1060780900352 wanted 39805 found 39797
parent transid verify failed on 
1060780900352 wanted 39805 found 39797
parent transid verify failed on 
1060780900352 wanted 39805 found 39797
Ignoring transid failure
Couldn't setup extent tree
Couldn't read fs root: -2
extent buffer leak: start 1060780900352 
len 16384

My setup: I have two 4tb drives in a 
single btrfs cluster in raid 0. I know, no 
need to mention how bad that idea was. So 
my wife is learning Linux and well let's 
say she's never allowed near the server 
again. She ran the command sudo rm -rf 
/media/Movies trying to delete a single 
file and that is why we are here.

Well, I had 1.5TB in that folder of 
hundreds of files. I could either spend 
another 2 months ripping all my DVDs again 
or recover my directory. I'm really 
surprised btrfs doesn't have better 
documentation on file recovery. Or a tool 
that can be used for this purpose. First 
thing I did when she told me about it is 
stop all processes writing to that mount,  
remove the btrfs volume from fstab and 
reboot. For some reason umount never works 
for me on the btrfs mounts.

So here is a partial lsblk. sde and sdb1 
are both in the volume together. I'm still 
not sure why sde  shows no partitions.

NAME   MAJ:MIN RM   SIZE RO TYPE  
MOUNTPOINT
sdb      8:16   0   3.7T  0 disk
â””â”€sdb1   8:17   0   3.7T  0 part
sde      8:64   0   3.7T  0 disk
sdf      8:80   0   1.8T  0 disk
â””â”€sdf1   8:81   0   1.8T  0 part  /media

Here is my entry in fstab:
UUID=7ffdecf9-af9a-4299-b697-4fc375bac3b1 
/media       btrfs   defaults  

So when I ran a sudo btrfs restore -s 
/dev/sde /tmp it restored some files. I 
had to stop it because I can't store 4TB 
on my root partition. I'd like to either 
recover /media/Movies from sde and sdb1. 
Or I would be willing to restore a 
snapshot but only of that one subdirectory 
as other data changes hourly.

So where can I start? I have run btrfs-
find-root /dev/sde and sdb1 and have the 
output files but I don't want to run the 
btrfs-undelete script since I get the 
errors above. I also noticed a strange 
line in the btrfs-undelete script I got 
from here: 
http://comments.gmane.org/gmane.comp.file-
systems.btrfs/22560

In the script, it references 
/dev/mapper/queen-home Now I've only been 
using Linux for a year now full time but 
I've never heard of that file.

Any ideas, questions, comments? I'm 
desperate so any help I can find would be 
greatly appreciated.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
