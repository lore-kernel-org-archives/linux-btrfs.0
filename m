Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:48605 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755973AbdKDBJG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 21:09:06 -0400
Received: by mail-oi0-f49.google.com with SMTP id m198so3415940oig.5
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 18:09:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7178555e-5f84-4e8a-243e-f1108d06136e@dirtcellar.net>
References: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
 <7178555e-5f84-4e8a-243e-f1108d06136e@dirtcellar.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 3 Nov 2017 19:09:05 -0600
Message-ID: <CAJCQCtTghZvbb8Nd7XGyHAUR5eq_Q0jBsRi-s8yXYwJz3b6szA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Parity=2Dbased_redundancy_=28RAID5=2F6=2Ftriple_parity_a?=
        =?UTF-8?Q?nd_beyond=29_on_BTRFS_and_MDADM_=28Dec_2014=29_=E2=80=93_Ronny_Egners_Bl?=
        =?UTF-8?Q?og?=
To: waxhead <waxhead@dirtcellar.net>
Cc: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For what it's worth, cryptsetup 2 now offers a UI for setting up both
dm-verity and dm-integrity.
https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/v2.0.0-rc0-ReleaseNotes

While more complicated than Btrfs, it's possible to first make an
integrity device on each drive, and add the integrity block devices to
mdadm or lvm as physical devices to create the raid1/10/5/6 array. You
could do it the other way around, but what should happen if you do it
as described, a sector read that fails checksum matching will cause a
read error to be handed off to md driver which then does
reconstruction from parity. If you only make the integrity volume out
of an array, then your file system just gets a read error whenever
there's a checksum mismatch, reconstruction isn't possible but at
least you're warned.

---
Chris Murphy
