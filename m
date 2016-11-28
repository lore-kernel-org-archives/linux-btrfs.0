Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:54379 "EHLO
        mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751307AbcK1TBb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:01:31 -0500
Date: Mon, 28 Nov 2016 20:01:29 +0100 (CET)
From: foss@rolf.leggewie.biz
To: linux-btrfs@vger.kernel.org
Message-ID: <1381094584.262772.1480359689092.JavaMail.ngmail@webmail11.arcor-online.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a multi-device btrfs (with problems, more on that later). I looked into btrfs-image and was surprised to find that "for i in 5 6 7 8 ; do sudo btrfs-image -t2 /dev/sda$i - | md5sum;done" returns a different hash for sda7.  The other three hashes are the same, as I believe they all should be, or am I mistaken?

$ for i in 5 6 7 8 ; do echo -n sda$i:" " ; sudo btrfs-image -t2 -c9 /dev/sda$i - | tee /tmp/sda$i.img | md5sum;done
sda5: 047a1da23edeb9661e79d1006f17eab0  -
sda6: 047a1da23edeb9661e79d1006f17eab0  -
sda7: 9cc7afdc1476daa6f671db8d3c855164  -
sda8: 047a1da23edeb9661e79d1006f17eab0  -

$ sudo btrfs fi show
Label: 'SSD128'  uuid: f110a925-6ad9-4b40-9207-6bf09ce0cb23
	Total devices 4 FS bytes used 105.96GiB
	devid    1 size 100.00GiB used 100.00GiB path /dev/sda5
	devid    2 size 10.00GiB used 10.00GiB path /dev/sda6
	devid    3 size 5.00GiB used 5.00GiB path /dev/sda7
	devid    4 size 1.99GiB used 1.00GiB path /dev/sda8

The difference is somewhere very early on in the file:
$ wc -c /tmp/sda?.img
223763456 /tmp/sda5.img
223763456 /tmp/sda6.img
223763456 /tmp/sda7.img
223763456 /tmp/sda8.img
895053824 total
$ for file in /tmp/sda?.img;do echo -n $file: " "; tail -c 222950000 $file | md5sum;done
/tmp/sda5.img:  afe8010fa089415aaa55f2d549c3b5d4  -
/tmp/sda6.img:  afe8010fa089415aaa55f2d549c3b5d4  -
/tmp/sda7.img:  afe8010fa089415aaa55f2d549c3b5d4  -
/tmp/sda8.img:  afe8010fa089415aaa55f2d549c3b5d4  -
$ for file in /tmp/sda?.img;do echo -n $file: " "; tail -c 222960000 $file | md5sum;done
/tmp/sda5.img:  2bc5fe13e5f2dd8592a24eecb322482e  -
/tmp/sda6.img:  2bc5fe13e5f2dd8592a24eecb322482e  -
/tmp/sda7.img:  ee26d34afa50ccb33e95e869b3e18af3  -
/tmp/sda8.img:  2bc5fe13e5f2dd8592a24eecb322482e  -

How could this be?

Regards

Rolf


PS: While I will check back for replies in the archive, a courtesy cc will be appreciated since I am not subscribed to the list.
