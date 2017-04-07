Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa67.mailout.artfiles.de ([212.72.176.67]:54913 "EHLO
        mailout-afa67.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755484AbdDGSYc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 14:24:32 -0400
Received: from [209.85.218.48] (helo=mail-oi0-f48.google.com)
        auth=smtp_senderkonto@kai-herlemann.de
        by mailout.artfiles.de with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80.1)
        id 1cwYYf-0005ol-9K
        for linux-btrfs@vger.kernel.org; Fri, 07 Apr 2017 20:24:29 +0200
Received: by mail-oi0-f48.google.com with SMTP id r203so95100536oib.3
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 11:24:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
From: Kai Herlemann <btrfs@linux.kai-herlemann.de>
Date: Fri, 7 Apr 2017 20:24:26 +0200
Message-ID: <CADN-S7N2gT57Q-iVfQj8SNh95F5NMmUAwsVNGM5a+GzjdA16hQ@mail.gmail.com>
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4 filesystem?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi @all who answered,
thank for your help and please excuse my late answer. I didn't see
your answers because of misconfiguration of my GMail filter for that
list.
The filesystem contains backups of some other filesystems (it's on a
external storage which is mirrored by RAID 1). So, if the filesystem
get lost, there are still the source partitions of the backups. But
you're right, I have to have actually more space purposes like using
btrfs-convert, which needs a backup, but can't/want afford that at the
moment because I'm student.

As far as I remember, I used in the past btrfs-convert to convert the
ext4 root partition of my laptop. It didn't really work with old
versions of btrfs-progs (I rollbacked it then or imported a backup),
but it worked with 4.4 or so.
Nevertheless, I won't use btrfs-convert after your warnings, and will
create a new filesystem and copy the data from ext4 to btrfs when I
have enough space.

Thank you all,
Kai
