From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 15:12:09 -0400
Message-ID: <4BF19509.6070505@redhat.com>
References: <4BF18525.8080904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Jakob Unterwurzacher <jakobunt@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF18525.8080904@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/2010 02:04 PM, Jakob Unterwurzacher wrote:
> Hi!
>
> Following Ubuntu's dpkg+ext4 problems I wanted to see if btrfs would
> solve them all. And it nearly does! Now I wonder if the remaining 0.2
> seconds window of exposing 0-size files could be closed too.
>    

Nearly does not seem that reassuring. What would happen if the server 
was under an intense load, swapping away crazily and running multiple 
writers to that same file system?

ric

> I tested using two simple scripts (attached for reference) on kernel
> 2.6.34-rc7:
> - rentest creates files $i.tmp and renames to $i.cur,
> - owtest does the same but overwrites existing $i.cur files,
> letting them run for 30-50 seconds then resetting the virtual machine.
>
> The results for ext3 are as expected: 0-size files are never exposed as
> $i.cur, overwrites are atomic.
>
> ext4 overwrites are /almost/ atomic (I get one 0-size file in owtest),
> lots of 0-size files are exposed in rentest (30 seconds window).
>
> btrfs *nearly* does as well as ext3. Overwrites are atomic.
>
> The rentest exposes only a 0.2 seconds windows of 0-size $i.cur files,
> so that a "ls --full-time" after the crash looks like this (notice the
> time between 01281.cur and 01292.tmp, only 0.2 seconds):
> [...]
> -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.812016407 +0200 01280.cur
> -rw-r--r-- 1 root root 20 2010-05-17 17:06:25.835999490 +0200 01281.cur
> -rw-r--r-- 1 root root  0 2010-05-17 17:06:25.868035485 +0200 01282.cur
> [...]
> -rw-r--r-- 1 root root  0 2010-05-17 17:06:26.080003626 +0200 01291.cur
> -rw-rw-rw- 1 root root  0 2010-05-17 17:06:26.108010083 +0200 01292.tmp
>
>
> Finally, xfs kills lots of existing files in owtest and exposes lots of
> 0-size files in rentest (both 40 seconds window).
>
> If anybody is interested, the bunch of trimmed "ls --full-time" output
> for all filesystems is attached.
>
>
> Thanks,
> Jakob
>    

