Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:32985 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756779AbcILOsv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:48:51 -0400
Received: by mail-oi0-f51.google.com with SMTP id y2so317181853oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:48:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$612d5$bc50d5d7$f1744b5$1e6b9281@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
 <pan$e206f$d515790a$646cc891$9e1c047e@cox.net> <CAJCQCtQz6cPhE1ciP5KJ2B5Ccy_5PSbzrmLmvh3rULoz_3h0bw@mail.gmail.com>
 <pan$612d5$bc50d5d7$f1744b5$1e6b9281@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 12 Sep 2016 08:48:49 -0600
Message-ID: <CAJCQCtTQfPGndDvL+mrMOMp4MH2E0Gd3xapGT5B9QP53aTi2sQ@mail.gmail.com>
Subject: Re: Small fs
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 10:54 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> On the bright side, the double-whammy of being under such tight
> filesystem size constraints, coupled with finding out you have less than
> half the space of the filesystem actually available due to default-mixed-
> mode AND default dup-metadata (thus dup everything),

I'm not following what you mean by default dup everything. You mean
that's how it used to work? Because on a real USB stick, 2GiB:


[chris@f24m ~]$ mkfs.btrfs -M /dev/sdb
btrfs-progs v4.7.2
See http://btrfs.wiki.kernel.org for more information.

probe of /dev/sdb failed, cannot detect existing filesystem.
ERROR: use the -f option to force overwrite of /dev/sdb
[chris@f24m ~]$ sudo mkfs.btrfs -M /dev/sdb
btrfs-progs v4.7.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               237d8ab9-b22f-435c-bbd8-2117afa1760c
Node size:          4096
Sector size:        4096
Filesystem size:    1.87GiB
Block group profiles:
  Data+Metadata:    single            8.00MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1     1.87GiB  /dev/sdb



Whereas without the -M


[chris@f24m ~]$ sudo mkfs.btrfs -f /dev/sdb
[sudo] password for chris:
btrfs-progs v4.7.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               a7c79550-10b8-4a4c-9b23-9c9110e30121
Node size:          16384
Sector size:        4096
Filesystem size:    1.87GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              95.56MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1     1.87GiB  /dev/sdb



So with -M, it's single by default..


-- 
Chris Murphy
