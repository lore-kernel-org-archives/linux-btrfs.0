Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33549 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbEJRcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 13:32:48 -0400
Received: by wgin8 with SMTP id n8so109908133wgi.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 10:32:46 -0700 (PDT)
Received: from [10.0.2.15] (p4FCB5E8C.dip0.t-ipconnect.de. [79.203.94.140])
        by mx.google.com with ESMTPSA id u9sm14382920wju.44.2015.05.10.10.32.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 May 2015 10:32:45 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <554F963D.2040209@googlemail.com>
Date: Sun, 10 May 2015 19:32:45 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according
 to dev stats
References: <554F6D43.2060806@googlemail.com> <554F7232.9080804@googlemail.com> <CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com>
In-Reply-To: <CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Again, last message was rejected.)

Hi Richard,

thank you for this tip, I didn't notice that btrfs-progs didn't match 
the kernel version.
I've updated btrfs-progs (from the repository, not manually installed), 
btrfs --version now shows v4.0.

However, it seems strange to me that a bunch of files is corrupted 
simply because btrfs-progs is older than the kernel.
To trigger more csum errors, I ran a script that basically finds all 
files and runs cat $file >/dev/null. I also scrubbed the filesystem.
It's getting worse. The number of corrupted files has grown to 79 - all 
in /home. Some of these files have not been modified in 3 years. I have 
copied them into this Arch vm from another vm, which runs Fedora (kernel 
3.19). The Fedora vm also uses btrfs, so it has the right checksums for 
all of those files. There are no csum errors in dmesg on that Fedora 
system. I've also started a scrub there, which has not generated any 
error yet. To be clear, we're talking about 50k something files (about 
11 GB) that I've copied onto this vm; I have used a handful of them and 
created <10.

So after copying a lot of files onto this Arch vm, many of them have 
been corrupted for unknown reasons (mostly old files, not changed on 
this Arch system).

Scrub:
# time btrfs scrub start -B / ; echo scrub $? done

scrub done for 3e8973d3-83ce-4d93-8d50-2989c0be256a
     scrub started at Sun May 10 17:47:34 2015 and finished after 427 
seconds
     total bytes scrubbed: 19.87GiB with 21941 errors
     error details: csum=21941
     corrected errors: 0, uncorrectable errors: 21941, unverified errors: 0
ERROR: There are uncorrectable errors.

During the scrub, I also saw several of these:
[19935.898678] __readpage_endio_check: 14 callbacks suppressed

I have started another scrub (now with v4.0), I still get errors but the 
affected file names are mentioned in dmesg, which is nice. Is there a 
btrfs status command that will list permanently damaged files as well 
(like zpool status -v), since dmesg will be empty after a reboot or crash?

I believe, thanks to Richard, I can now answer my second question: The 
old version 3.19 failed to increase the error counter(s) in dev stats, 
but this is apparently fixed in 4.0 (so a monitoring job would now be 
able to notify an admin):
$ sudo btrfs dev stats / | grep -v 0
[/dev/sda1].corruption_errs 43882



Thanks
Philip

On 05/10/2015 05:33 PM, Richard Michael wrote:
> Hi Philip,
>
> Have you tried latest btrfs-progs?
>
> The progs release version has sync'd up with the kernel version, so 
> your kernel v4.0.1 with progs v3.19.1 could be taken as a "mismatch".
>
> I haven't read the progs v3.19.1 v4.0 commit diff, and the wiki 
> doesn't mention csum fixes/work related to corruption, but, in your 
> situation, I'd probably try out v4.0 progs to be sure.
>
> https://btrfs.wiki.kernel.org/index.php/Main_Page#News
>
> Sorry I don't have more than this to offer.
>
>
> Regards,
> Richard
>
>
> On Sun, May 10, 2015 at 10:58 AM, Philip Seeger <p0h0i0l0i0p@gmail.com 
> <mailto:p0h0i0l0i0p@gmail.com>> wrote:
>
>     Forgot to mention kernel version: Linux 4.0.1-1-ARCH
>
>     $ sudo btrfs fi show
>     Label: none  uuid: 3e8973d3-83ce-4d93-8d50-2989c0be256a
>         Total devices 1 FS bytes used 19.87GiB
>         devid    1 size 45.00GiB used 21.03GiB path /dev/sda1
>
>     btrfs-progs v3.19.1
>
>
>
>
>     On 05/10/2015 04:37 PM, Philip Seeger wrote:
>
>         I have installed a new virtual machine (VirtualBox) with Arch
>         on btrfs
>         (just a root fs and swap partition, no other partitions).
>         I suddenly noticed 10 checksum errors in the kernel log:
>         $ dmesg | grep csum
>         [  736.283506] BTRFS warning (device sda1): csum failed ino
>         1704363 off
>         761856 csum 1145980813 expected csum 2566472073
>         [  736.283605] BTRFS warning (device sda1): csum failed ino
>         1704363 off
>         1146880 csum 1961240434 expected csum 2566472073
>         [  745.583064] BTRFS warning (device sda1): csum failed ino
>         1704346 off
>         393216 csum 4035064017 expected csum 2566472073
>         [  752.324899] BTRFS warning (device sda1): csum failed ino
>         1705927 off
>         2125824 csum 3638986839 expected csum 2566472073
>         [  752.333115] BTRFS warning (device sda1): csum failed ino
>         1705927 off
>         2588672 csum 176788087 expected csum 2566472073
>         [  752.333303] BTRFS warning (device sda1): csum failed ino
>         1705927 off
>         3276800 csum 1891435134 expected csum 2566472073
>         [  752.333397] BTRFS warning (device sda1): csum failed ino
>         1705927 off
>         3964928 csum 3304112727 expected csum 2566472073
>         [ 2761.889460] BTRFS warning (device sda1): csum failed ino
>         1705927 off
>         2125824 csum 3638986839 expected csum 2566472073
>         [ 9054.226022] BTRFS warning (device sda1): csum failed ino
>         1704363 off
>         761856 csum 1145980813 expected csum 2566472073
>         [ 9054.226106] BTRFS warning (device sda1): csum failed ino
>         1704363 off
>         1146880 csum 1961240434 expected csum 2566472073
>
>         This is a new vm, it hasn't crashed (which might have caused
>         filesystem
>         corruption). The virtual disk is on a RAID storage on the
>         host, which is
>         healthy. All corrupted files are Firefox data files:
>         $ dmesg | grep csum | grep -Eo 'csum failed ino [0-9]* ' | awk
>         '{print
>         $4}' | xargs -I{} find -inum {}
>         ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>         ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>         ./.mozilla/firefox/nfh217zw.default/webappsstore.sqlite
>         ./.mozilla/firefox/nfh217zw.default/places.sqlite
>         ./.mozilla/firefox/nfh217zw.default/places.sqlite
>         ./.mozilla/firefox/nfh217zw.default/places.sqlite
>         ./.mozilla/firefox/nfh217zw.default/places.sqlite
>         ./.mozilla/firefox/nfh217zw.default/places.sqlite
>         ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>         ./.mozilla/firefox/nfh217zw.default/cookies.sqlite
>
>         How could this possibly happen?
>
>         And more importantly: Why doesn't the btrfs stat(u)s output
>         tell me that
>         errors have occurred?
>         $ sudo btrfs dev stats /
>         [/dev/sda1].write_io_errs   0
>         [/dev/sda1].read_io_errs    0
>         [/dev/sda1].flush_io_errs   0
>         [/dev/sda1].corruption_errs 0
>         [/dev/sda1].generation_errs 0
>
>         If the filesystem health was monitored using btrfs dev stats
>         (cronjob)
>         (like checking a zpool using zpool status), the admin would
>         not have
>         been notified:
>         $ sudo btrfs dev stats / | grep -v 0 -c
>         0
>
>         Is my understanding of the stats command wrong, does
>         "corruption_errs"
>         not mean corruption errors?
>
>
>
>
>     -- 
>     Philip
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-btrfs" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>

