From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re: Bug
 in mkfs.btrfs?!)
Date: Wed, 26 Jan 2011 23:25:18 +0100
Message-ID: <20110126222518.GB2561@scooter>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

attached is the answer from Jari Ruusu, (one of?!) the main developer of loop-aes. It
seems that checking if a loop device is mounted following the link isn't the best
idea :)

I'll have time to look deeper into his example about the 14.02. I'll then try to fix
that issue in mkfs.btrfs. If someone wants to fix it earlier, do it :) 



Regards,
Felix

--J2SCkAp4GZ/dPZZf
Content-Type: message/rfc822
Content-Disposition: inline

Delivered-To: felixblanke@gmail.com
Received: by 10.223.115.82 with SMTP id h18cs48355faq;
        Wed, 26 Jan 2011 04:39:46 -0800 (PST)
Received: by 10.213.28.12 with SMTP id k12mr1099173ebc.84.1296045585664;
        Wed, 26 Jan 2011 04:39:45 -0800 (PST)
Return-Path: <jariruusu@users.sourceforge.net>
Received: from mail.tnnet.fi (mail.tnnet.fi [217.112.240.26])
        by mx.google.com with ESMTPS id q16si36115376eeh.70.2011.01.26.04.39.45
        (version=TLSv1/SSLv3 cipher=RC4-MD5);
        Wed, 26 Jan 2011 04:39:45 -0800 (PST)
Received-SPF: neutral (google.com: 217.112.240.26 is neither permitted nor denied by best guess record for domain of jariruusu@users.sourceforge.net) client-ip=217.112.240.26;
Authentication-Results: mx.google.com; spf=neutral (google.com: 217.112.240.26 is neither permitted nor denied by best guess record for domain of jariruusu@users.sourceforge.net) smtp.mail=jariruusu@users.sourceforge.net
Received: from localhost (localhost [127.0.0.1])
	by mail.tnnet.fi (Postfix) with ESMTP id EAEE617B443;
	Wed, 26 Jan 2011 14:39:44 +0200 (EET)
X-Virus-Scanned: amavisd-new at tnnet.fi
Received: from mail.tnnet.fi ([127.0.0.1])
	by localhost (mail.tnnet.fi [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id OR05S1q6mXM0; Wed, 26 Jan 2011 14:39:44 +0200 (EET)
Received: from a64.adsl.tnnet.fi (a64.adsl.tnnet.fi [217.112.242.64])
	by mail.tnnet.fi (Postfix) with ESMTP id 5271E17B442;
	Wed, 26 Jan 2011 14:39:44 +0200 (EET)
Message-ID: <4D40160E.605750DF@users.sourceforge.net>
Date: Wed, 26 Jan 2011 14:39:42 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Felix Blanke <felixblanke@gmail.com>
CC: linux-crypto@kernelnewbies.org
Subject: Re: Problem with losetup
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

First of all, I am not subscribed to linux-crypto@kernelnewbies.org mailing
list. But I do check web archive occasionally, at least for now. If you want
loop-AES maintainer to see your posts, please CC my @users.sourceforge.net
address, or linux-crypto@vger.kernel.org

Felix Blanke wrote:
> If I'm using the unpatched losetup (from util-linux-ng) and looping a
> device like
> 
> /dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3
> 
> it is using readlink to track down the link to e.g. /dev/sda3. But if
> I'm using the patched losetup I don't see any readlink in the strace.
> Because no readlink is used there is a problem with device names which
> have more then 64 characters (the field "lo_name" is an array of 64
> char). It is truncated like
> 
> /dev/loop0: [0010]:6229
> (/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par)
> encryption=AES128
> 
> That does make trouble with e.g. btrfs, because mkfs.btrfs uses the
> devicename provided by losetup to check if a device is mounted. That
> can't work with an incomplete devicename.

mkfs.btrfs authors goofed. Using truncated name is doomed to fail. Correct
way to check that is to compare loop backing file inode and device numbers
to inode and device numbers of supected file. Here is sample losetup output:

/dev/loop6: [0902]:209029 (/dev/md3) offset=4096 encryption=AES128 multi-key-v3
             ^^^^  ^^^^^^
          device     inode

Device number (0902) is hexadecimal. Inode number (209029) is decimal
number. /dev/md3 block special device node is present at mounted file system
on device 0x0902. Anything that symlinks or hardlinks to that inode 209029
on device 0x0902, is same file or device.
    
Even if losetup were to follow symlinks for that backing file name, symlink
destination would not necessarily be shorter. Although in your case it would
be shorter. Also, old versions of cryptoloop do not store the backing file
name at all. They use that same space for cipher algorithm name.

Below is source code for correct way for mkfs.btrfs to test loop backing
file status. Feel free to forward it to mkfs.btrfs authors.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD



/* loop-backing-dev-check.c / (c) 2011 Jari Ruusu / GNU GPL */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <linux/loop.h>

int loop_backing_dev_check(char *loopdev, char *suspect)
{
    int fd, ret = 0;
    struct stat statbuf;
    struct loop_info64 info64;
    struct loop_info info;

    if(!loopdev || !*loopdev || !suspect || !*suspect) goto outret0;
    if(stat(loopdev, &statbuf) || !S_ISBLK(statbuf.st_mode)) goto outret0;
    if((statbuf.st_rdev & 0xfff00) != 0x700) goto outret0;
    if(stat(suspect, &statbuf)) goto outret0;
    if((fd = open(loopdev, O_RDONLY)) < 0) goto outret0;
    if(!ioctl(fd, LOOP_GET_STATUS64, &info64)) {
	if(statbuf.st_dev != info64.lo_device) goto closeret0;
	if(statbuf.st_ino != info64.lo_inode) goto closeret0;
	ret = 1;   /* loop backing device/file is same as suspect */
    } else if(!ioctl(fd, LOOP_GET_STATUS, &info)) {
	if(statbuf.st_dev != info.lo_device) goto closeret0;
	if(statbuf.st_ino != info.lo_inode) goto closeret0;
	ret = 1;   /* loop backing device/file is same as suspect */
    }
 closeret0:
    close(fd);
 outret0:
    return ret;
}

/* usage: ./loop-backing-dev-check /dev/loop0 /dev/fd0 */
int main(int argc, char **argv)
{
    if(argc != 3) exit(1);
    if(loop_backing_dev_check(argv[1], argv[2])) {
        printf("loop device %s is associated with %s\n", argv[1], argv[2]);
        exit(0);
    }
    exit(1);
}

--J2SCkAp4GZ/dPZZf--
