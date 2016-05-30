Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33686 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbcE3CGT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 22:06:19 -0400
Received: by mail-oi0-f68.google.com with SMTP id m198so23147999oig.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:06:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR4rcADvAGy_Wv4afaHRJJLV3M_1jQhBT5Ky6e=4TSsNQ@mail.gmail.com>
References: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
	<CAJCQCtS3hG8nQ39bAnKpSz-9kBhiPY6wFM2t3g5Ek-RNnx1DFA@mail.gmail.com>
	<CAJCQCtR4rcADvAGy_Wv4afaHRJJLV3M_1jQhBT5Ky6e=4TSsNQ@mail.gmail.com>
Date: Sun, 29 May 2016 20:06:18 -0600
Message-ID: <CAJCQCtQYRfhkNSBLEJ8=ERT6UD5h6zC4cYyrfMWrvDGEmXYQ_A@mail.gmail.com>
Subject: Re: [regression] make sure seed is writeable sprout after device add
From: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 8:03 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> # lsblk -o +UUID
> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT UUID
> loop0    7:0    0    10G  0 loop /mnt/0     63288b0c-9216-4f11-aed4-cc054ae90e07
> loop1    7:1    0    10G  0 loop            63288b0c-9216-4f11-aed4-cc054ae90e07
>
> This is worse.
>
> # btrfs fi show
> Label: none  uuid: 63288b0c-9216-4f11-aed4-cc054ae90e07
>     Total devices 2 FS bytes used 384.00KiB
>     devid    1 size 10.00GiB used 2.02GiB path /dev/loop0
>     devid    2 size 10.00GiB used 0.00B path /dev/loop1
>
> So is this. Where is the new UUID for the newly created sprout volume?
>
> /dev/loop0: UUID="63288b0c-9216-4f11-aed4-cc054ae90e07"
> UUID_SUB="e379aedb-6d14-4d56-be7d-1772c9984bc5" TYPE="btrfs"
> /dev/loop1: UUID="63288b0c-9216-4f11-aed4-cc054ae90e07"
> UUID_SUB="b282f566-8382-468e-b9ec-f748244b703b" TYPE="btrfs"
>
> Uhh? Identical UUIDs for seed and sproud? That's not right.


Just to confirm that UUID for the sprout is the same as the seed at
mkfs time, and I didn't include it in the previous email:


# mkfs.btrfs /dev/loop0
btrfs-progs v4.5.2
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (10.00GiB) ...
Label:              (null)
UUID:               63288b0c-9216-4f11-aed4-cc054ae90e07



-- 
Chris Murphy
