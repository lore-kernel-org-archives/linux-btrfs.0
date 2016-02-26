Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35676 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbcBZKuN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 05:50:13 -0500
Received: by mail-io0-f169.google.com with SMTP id g203so118240700iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 02:50:12 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 26 Feb 2016 10:50:12 +0000
Message-ID: <CAO5K3OdzXgXpSNqCOqvMwVgQWiEF9p91ymB+uXjFRCCK24QWZg@mail.gmail.com>
Subject: upgrading kernel 3.13 to 3.16
From: Vytautas D <vytdau@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Are there any known issues upgrading btrfs running ubuntu kernel 3.13
to 3.16 ? System was once converted from ext4 using btrfs-convert (
btrfs-progs 3.17 ).

The commit that worries me is following:
*  Btrfs: incompatible format change to remove hole extents (+373/-56)
( http://linux-btrfs.vger.kernel.narkive.com/syNRZbHS/patch-btrfs-incompatible-format-change-to-remove-hole-extents-v3#post1
)

would this block me from reverting system with a snapshot back to kernel 3.13 ?
After upgrade would the system continue writing more metadata ?

Thanks,
Vytas
