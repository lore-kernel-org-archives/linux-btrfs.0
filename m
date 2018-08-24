Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727412AbeHXRHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 13:07:20 -0400
Subject: Re: rm or mv of directories (with subdirectories) hang with no
 message
To: Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJVZm6dwNq18gykoVJBTLDf1WVsf2E1s1rpEp32HLXcOvA_+_A@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f06a4ca1-ac07-4a62-9bbc-8b050d52f9b1@suse.com>
Date: Fri, 24 Aug 2018 16:32:35 +0300
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dwNq18gykoVJBTLDf1WVsf2E1s1rpEp32HLXcOvA_+_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.08.2018 16:24, Menion wrote:
> Hi all
> I have been experiencing an issue that I believe can be quite easily
> reproduced attempting to recursively rm (mv is also affected) a
> directory containing some subdirectories and files.
> The problem affects my system that run root BTRFS filesystem created
> by Ubuntu server installer (so kernel 4.4.0 at the time of creation)
> on an eMMC, and a storage RAID5 array (5x8Tb HDD) created with kernel
> 4.15.x
> I have been observing this issue since kernel 4.15, now I run kernel
> 4.17.3 and hit the issue again
> The issue pops up when you try to "rm -Rf" a directory that contains
> some subdirectories with some files inside.
> I have intentionally written "some" because I don't know how many
> subdirectories are necessary to reproduce the problem, but don't
> expect to have the problem with a couple of subdir and few dozen of
> files inside.
> You launch "rm -Rf" and after an insane amount of time (half an hour
> or more) the process is still running. You can CTRL+Z and kill it. If
> you start to "rm -Rf" one by one the subdirectories, starting from
> inner one, you can remove all the way to the upper directory, meaning
> that the filesystem is ok.
> There is absolutely ZERO log in dmesg, meaning no log from neither
> BTRFS, SCSI or USB (in my case the RAID5 array it is an external USB
> enclosure).
> Note that it affect a single BTRFS on eMMC and a BTRFS RAID5 on USB
> enclosure, so it really seem being BTRFS releated.
> Step to reproduce (as it happened just right now):
> Clone CoreELEC (multimedia JeOS) and compile:
> 
> git clone https://github.com/CoreELEC/CoreELEC.git
> cd CoreELEC
> git checkout tags/8.95.0
> PROJECT=Amlogic DEVICE=S912 ARCH=arm make image
> 
> Leave it running for 2-3 hours so it can download and decompress
> packages, increasing the level of subdirectories and files. Then kill
> the compilation and try to remove the root directory: "rm -Rf
> CoreELEC" (or mv it to another medium)
> Result: it should takes some minutes, but after half an hour rm
> process is still running.
> Bye
> 

Provide stacktraces of the hung process when the issue occurs:

cat /proc/PID/stack also
echo w > /proc/sysrq-trigger
