Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43031 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaDSL0o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 07:26:44 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so1989001lbi.36
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 04:26:42 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 19 Apr 2014 13:26:42 +0200
Message-ID: <CAOTaaruU9MWeSmeYkhmhutjL5LE5aj9SDyb4G9XuqgLD647z0A@mail.gmail.com>
Subject: Balance interrupted twice, not mountable fs
From: Dario Santamaria <dario.santamaria@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,
after 2 power down during "btrfs balance" (I'm a very lucky man), now
my fs is not mountable.
It's an SSD with btrfs as the main root partition. Have Debian
testing, kernel 3.13.10 with btrfs-progs from git (cloned yesterday).
I know data is there, but I can't use it.

matrix64:~/tmpgit/btrfs-progs# ./btrfs version
Btrfs v3.14.1
matrix64:~/tmpgit/btrfs-progs# ./btrfs fi show /dev/sdb1
Label: 'debianssd'  uuid: c6a9e831-1c83-459c-a2e3-d2e192f9dd17
        Total devices 1 FS bytes used 100.15GiB
        devid    1 size 108.03GiB used 108.02GiB path /dev/sdb1

Btrfs v3.14.1
matrix64:~/tmpgit/btrfs-progs# mount -v -t btrfs /dev/sdb1 ~/pendrive/
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

matrix64:~/tmpgit/btrfs-progs# dmesg|tail -50
[...]
[ 3424.805108] btrfs: device label debianssd devid 1 transid 2032022 /dev/sdb1
[ 3565.122729] btrfs: device label debianssd devid 1 transid 2032022 /dev/sdb1
[ 3565.124126] btrfs: disk space caching is enabled
[ 3565.127616] parent transid verify failed on 126732546048 wanted
2032022 found 2032019
[ 3565.128113] parent transid verify failed on 126732546048 wanted
2032022 found 2032019
[ 3565.128116] btrfs: failed to read tree root on sdb1
[ 3565.134066] btrfs: open_ctree failed
matrix64:~/tmpgit/btrfs-progs#

I tried all the option to mount: "recovery", "recovery,ro",
"recovery,noatime,clear_cache", "recovery,noatime,nospace_cache" with
no luck.
Then I tried a "./btrfs rescue chunk-recover -vy /dev/sdb1" but it failed with:

[...]
Orphan Device Extents:
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
Ignoring transid failure
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
Ignoring transid failure
leaf parent key incorrect 126736531456
Couldn't setup extent tree
open with broken chunk error
Fail to recover the chunk tree.

Full log here: http://www.freezonestudio.com/btrfs-recover.txt

Finally the btrfs check exit with Segmentation Fault...

matrix64:~/tmpgit/btrfs-progs# ./btrfs check --repair /dev/sdb1
enabling repair mode
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
parent transid verify failed on 126732546048 wanted 2032022 found 2032019
Ignoring transid failure
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
Ignoring transid failure
leaf parent key incorrect 126736531456
Couldn't setup extent tree
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126733086720 wanted 2032019 found 2032022
parent transid verify failed on 126736531456 wanted 2032019 found 2032022
Ignoring transid failure
leaf parent key incorrect 126736531456
Couldn't setup device tree
Checking filesystem on /dev/sdb1
UUID: c6a9e831-1c83-459c-a2e3-d2e192f9dd17
Critical roots corrupted, unable to fsck the FS
Errore di segmentazione
matrix64:~/tmpgit/btrfs-progs#

Any test? Any hint? Any suggestion?

Thank you all,
Dario Santamaria
google.com/+DarioSantamaria
www.santasoft.it
www.jugpadova.it
