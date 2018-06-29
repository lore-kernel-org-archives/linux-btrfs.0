Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:41904 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934025AbeF2Xj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 19:39:29 -0400
Received: by mail-ot0-f193.google.com with SMTP id d19-v6so11653036oti.8
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 16:39:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <028df9e3bc13286d08fade17fe90b179@livingrock.ca>
References: <028df9e3bc13286d08fade17fe90b179@livingrock.ca>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 29 Jun 2018 17:39:27 -0600
Message-ID: <CAJCQCtRmr21vUkcFhT52eTokei8eSBpapzxzd47xWAFY40-U1Q@mail.gmail.com>
Subject: Re: Removed Disk - Super Error - Scrub did not fix - next steps?
To: j@livingrock.ca
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 11:55 AM,  <j@livingrock.ca> wrote:
> Hello,
>
> I recently was mounting some drives in the free drive bays of my server and
> accidentally removed one of my drives from my raid1 btrfs array.  I
> immediately put it back in - but whatever damage that would have caused
> seems to be already done.
>
> I got these log errors [dmesg -T] and after reading up it seemed that all I
> *probably* needed to do was a scrub:
>
> Finally - the original logs I found by running "dmesg -T|grep -i btrfs" -
> from where the log started to where the scrub begain:
>
> [Tue Jun 26 18:30:08 2018] BTRFS error (device sdb): bdev /dev/sdh errs: wr
> 40547, rd 42808, flush 2, corrupt 0, gen 0
>
> [Tue Jun 26 18:33:19 2018] btrfs_dev_stat_print_on_error: 2056 callbacks
> suppressed
>
> A bunch of these errors...
>
> Then later:
>
> [Tue Jun 26 19:19:52 2018] BTRFS warning (device sdb): lost page write due
> to IO error on /dev/sdh
>
> I think this is where I unmounted/remounted /mnt/titan:
>
> [Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): disk space caching is
> enabled
> [Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): has skinny extents
> [Tue Jun 26 19:49:18 2018] BTRFS info (device sdb): bdev /dev/sdh errs: wr
> 55907, rd 59133, flush 2, corrupt 0, gen 0
> [Tue Jun 26 19:49:57 2018] btrfs_dev_stat_print_on_error: 49 callbacks
> suppressed
> [Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: wr
> 55907, rd 59133, flush 2, corrupt 0, gen 1
> [Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: wr
> 55907, rd 59133, flush 2, corrupt 0, gen 2
> [Tue Jun 26 19:49:57 2018] BTRFS error (device sdb): bdev /dev/sdh errs: wr
> 55907, rd 59133, flush 2, corrupt 0, gen 3
> [Tue Jun 26 19:50:09 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081264963584 wanted 8663 found 8321
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081264963584 (dev /dev/sdh sector 17728418112)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081264967680 (dev /dev/sdh sector 17728418120)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081264971776 (dev /dev/sdh sector 17728418128)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081264975872 (dev /dev/sdh sector 17728418136)
> [Tue Jun 26 19:50:09 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081265356800 wanted 8663 found 8321
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265356800 (dev /dev/sdh sector 17728418880)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265360896 (dev /dev/sdh sector 17728418888)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265364992 (dev /dev/sdh sector 17728418896)
> [Tue Jun 26 19:50:09 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265369088 (dev /dev/sdh sector 17728418904)



These are passive fixups that succeed.


>
> According to btrfs scrub status this is when the scrub began...
>
> [Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081265061888 wanted 8663 found 8321
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265061888 (dev /dev/sdh sector 17728418304)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265065984 (dev /dev/sdh sector 17728418312)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265070080 (dev /dev/sdh sector 17728418320)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081265074176 (dev /dev/sdh sector 17728418328)
> [Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081263046656 wanted 8664 found 8662
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263046656 (dev /dev/sdh sector 17728414368)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263050752 (dev /dev/sdh sector 17728414376)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263054848 (dev /dev/sdh sector 17728414384)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263058944 (dev /dev/sdh sector 17728414392)
> [Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081263194112 wanted 8664 found 8662
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263194112 (dev /dev/sdh sector 17728414656)
> [Tue Jun 26 19:50:29 2018] BTRFS info (device sdb): read error corrected:
> ino 0 off 9081263198208 (dev /dev/sdh sector 17728414664)
> [Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081264128000 wanted 8664 found 8662
> [Tue Jun 26 19:50:29 2018] BTRFS error (device sdb): parent transid verify
> failed on 9081265520640 wanted 8665 found 8321

Fixups during scrub also succeed.


>
> So I ran btrfs scrub and this was my post-scrub status:
>
> Idoru:/ # btrfs scrub status -d /mnt/titan
> scrub status for e7c494fc-ac4e-4644-a2f2-66f25543708b
> scrub device /dev/sdb (id 1) history
>     scrub started at Tue Jun 26 19:50:29 2018 and finished after 16:10:04
>     total bytes scrubbed: 8.57TiB with 0 errors
> scrub device /dev/sdh (id 2) history
>     scrub started at Tue Jun 26 19:50:29 2018 and finished after 16:13:31
>     total bytes scrubbed: 8.57TiB with 3 errors
>     error details: super=3
>     corrected errors: 0, uncorrectable errors: 0, unverified errors: 0
>
> On a side note - I'm not sure if it matters (or why it might/could/would) -
> but I actually used entire drives [as opposed to making partitions and using
> them] to create my mirror.

Doesn't matter.



> I unmounted again and ran btrfs check [without repair] again - after doing
> scrub:
>
> Idoru:/ # btrfs check /dev/sdh
> Checking filesystem on /dev/sdh
> UUID: e7c494fc-ac4e-4644-a2f2-66f25543708b
> checking extents
> checking free space cache
> checking fs roots
> checking only csum items (without verifying data)
> checking root refs
> found 9414630215796 bytes used, no error found
> total csum bytes: 9191775488
> total tree bytes: 12803850240
> total fs tree bytes: 3054665728
> total extent tree bytes: 230211584
> btree space waste bytes: 782320214
> file data blocks allocated: 132510269804544
>  referenced 132509780557824
>
> Idoru:/ # btrfs check /dev/sdb
> Checking filesystem on /dev/sdb
> UUID: e7c494fc-ac4e-4644-a2f2-66f25543708b
> checking extents
> checking free space cache
> checking fs roots
> checking only csum items (without verifying data)
> checking root refs
> found 9414630215796 bytes used, no error found
> total csum bytes: 9191775488
> total tree bytes: 12803850240
> total fs tree bytes: 3054665728
> total extent tree bytes: 230211584
> btree space waste bytes: 782320214
> file data blocks allocated: 132510269804544
>  referenced 132509780557824


FWIW you only need to check once. It doesn't matter which device you
pass to btrfs check, it finds the other devices and they all get
checked.




>
> Everything seems identical [and OK].
>
> So I tried remounting and found the following in my dmesg log:
>
> Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): disk space caching is
> enabled
> [Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): has skinny extents
> [Fri Jun 29 13:27:21 2018] BTRFS info (device sdb): bdev /dev/sdh errs: wr
> 55907, rd 59133, flush 2, corrupt 0, gen 3
>
> So I still seem to have a problem...


The bdev stats is a counter, not an active error message. If you want
to zero out the counter, use -z option with btrfs dev stats.



> I guess I'm wondering why the super errors were not corrected in the scrub
> [uncorrectable errors:0 - super but it didn't correct - or even try to -
> correct the super errors]?

You can use 'btrfs rescue super -v' to check all the supers separately
from any other check. But the supers would have been fixed
automatically right off the bat with a normal mount in this case.



-- 
Chris Murphy
