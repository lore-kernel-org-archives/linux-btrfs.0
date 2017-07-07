Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37780 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdGGGId (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 02:08:33 -0400
Received: by mail-it0-f49.google.com with SMTP id m84so25866670ita.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 23:08:32 -0700 (PDT)
From: Daniel Brady <drbrady@gmail.com>
Subject: Re: Chunk root problem
To: 1i5t5.duncan@cox.net, linux-btrfs@vger.kernel.org
Message-ID: <588f0270-3223-d969-0c62-4c421f61280c@gmail.com>
Date: Fri, 7 Jul 2017 00:08:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/6/2017 2:26 AM, Duncan wrote:
> Daniel Brady posted on Wed, 05 Jul 2017 22:10:35 -0600 as excerpted:
>
>> My system suddenly decided it did not want to mount my BTRFS setup. I
>> recently rebooted the computer. When it came back, the file system was
>> in read only mode. I gave it another boot, but now it does not want to
>> mount at all. Anything I can do to recover? This is a Rockstor setup
>> that I have had running for about a year.
>>
>> uname -a
>> Linux hobonas 4.10.6-1.el7.elrepo.x86_64 #1 SMP Sun Mar 26
>> 12:19:32 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs --version
>> btrfs-progs v4.10.1
>
> FWIW, open ctree failed is the btrfs-generic error, but the transid
> faileds may provide some help.
>
> Addressing the easy answer first...
>
> What btrfs raid mode was it configured for?  If raid56, you want the
> brand new 4.12 kernel at least, as there were serious bugs in previous
> kernels' raid56 mode.  DO NOT ATTEMPT A FIX OF RAID56 MODE WITH AN
> EARLIER KERNEL, IT'S VERY LIKELY TO ONLY CAUSE FURTHER DAMAGE!  But if
> you're lucky, kernel 4.12 can auto-repair it.
>
> With those fixes the known bugs are fixed, but we'll need to wait a
> few
> cycles to see what the reports are.  Even then, however, due to the
> infamous parity-raid write hole and the fact that the parity isn't
> checksummed, it's not going to be as stable as raid1 or raid10 mode.
> Parity-checksumming will take a new implementation and I'm not sure if
> anyone's actually working on that or not.  But at least until we see
> how
> stable the newer raid56 code is, 2-4 kernel cycles, it's not
> recommended
> except for testing only, with even more backups than normal.
>
> If you were raid1 or raid10 mode, the raid mode is stable so it's a
> different issue.  I'll let the experts take it from here.  Single or
> raid0 mode would of course be similar, but without the protection of
> the
> second copy, making it less resilient.

The raid mode was configured for raid56... unfortunately. I learned of
the potential instability after it died. I have not attempted to repair
it yet because of the possible corruption. I've only tried various ways
of mounting it and dry runs of the restore function.

I did as you mentioned and upgraded to kernel 4.12. The auto-repair
seemed to fix quite a few things, but it is not quite there. Even with a
few reboots.

uname -r
4.12.0-1.el7.elrepo.x86_64

rpm -qa | grep btrfs
btrfs-progs-4.10.1-0.rockstor.x86_64

dmesg
[   21.400190] BTRFS info (device sdb): use no compression
[   21.400191] BTRFS info (device sdb): disk space caching is enabled
[   21.400192] BTRFS info (device sdb): has skinny extents
[   21.584923] BTRFS info (device sdb): bdev /dev/sde errs: wr 402545,
rd 234683174, flush 194501, corrupt 0, gen 0
[   23.394788] BTRFS error (device sdb): parent transid verify failed on
5257838690304 wanted 591492 found 489231
[   23.416489] BTRFS error (device sdb): parent transid verify failed on
5257838690304 wanted 591492 found 489231
[   23.416524] BTRFS error (device sdb): failed to read block groups: -5
[   23.448478] BTRFS error (device sdb): open_ctree failed

-Dan
