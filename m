Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.111]:45370 "EHLO
        mail1.arhont.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932229AbdJXJ0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 05:26:53 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id 3E6171400A98
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 10:20:17 +0100 (BST)
Received: from mail1.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GMtdiSbGBHoM for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 10:20:16 +0100 (BST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id 12F3B1400A9C
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 10:20:16 +0100 (BST)
Received: from mail1.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HpIeUCoKTo4R for <linux-btrfs@vger.kernel.org>;
        Tue, 24 Oct 2017 10:20:15 +0100 (BST)
Received: from mail1.arhont.com (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id DBF981400A98
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 10:20:15 +0100 (BST)
Date: Tue, 24 Oct 2017 10:20:15 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
In-Reply-To: <7560696.184.1508834006162.JavaMail.gkos@dynomob>
Subject: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

having installed the recent kernel version I am no longer able to mount the btrfs partition with compression on the first attempt. Previously on 4.10.0-37-generic everything was working fine, once I switched to 4.13.9-041309-generic I started getting the following error while trying to mount it with the same  options "compress-force=zlib,space_cache=v2"

[  204.596381] BTRFS error (device sda): open_ctree failed
[  204.631895] BTRFS info (device sda): force zlib compression
[  204.631901] BTRFS info (device sda): using free space tree
[  204.631903] BTRFS info (device sda): has skinny extents
[  204.890145] BTRFS error (device sda): super_total_bytes 32004083023872 mismatch with fs_devices total_rw_bytes 64008166047744
[  204.891276] BTRFS error (device sda): failed to read chunk tree: -22
[  204.944333] BTRFS error (device sda): open_ctree failed

For some reason, the super_total_bytes is exactly half of total_rw_bytes.


however, if after unsuccessful first mount attempt, I mount it with minimum number of options "space_cache=v2" the partition mounts. Then I umount it, and mount normally, with full set of options "compress-force=zlib,space_cache=v2" it mounts without an error.
I also observed the same error on 4.12.14-041214-generic
Any ideas why this might be happening?



System information

distribution: Ubuntu 16.04
btrfs-progs v4.8.1 later upgraded to v4.13.3

# btrfs fi usage /mnt/backup
Overall:
    Device size:                  29.11TiB
    Device allocated:             18.04TiB
    Device unallocated:           11.07TiB
    Device missing:                  0.00B
    Used:                         17.99TiB
    Free (estimated):             11.12TiB      (min: 5.58TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:17.93TiB, Used:17.88TiB
   /dev/sda       17.93TiB

Metadata,DUP: Size:53.50GiB, Used:51.78GiB
   /dev/sda      107.00GiB

System,DUP: Size:8.00MiB, Used:2.30MiB
   /dev/sda       16.00MiB

Unallocated:
   /dev/sda       11.07TiB




Yours sincerely,
Konstantin V. Gavrilenko


