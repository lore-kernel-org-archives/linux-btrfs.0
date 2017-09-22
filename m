Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:56334 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGcD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 02:32:03 -0400
Received: by mail-qt0-f182.google.com with SMTP id l25so148300qtf.13
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 23:32:03 -0700 (PDT)
MIME-Version: 1.0
From: shally verma <shallyvermacavium@gmail.com>
Date: Fri, 22 Sep 2017 12:01:32 +0530
Message-ID: <CAP9W88hYMu5y-7MjKnSpTymo8WiBsZ1sag-NY9a_kLfqctaz5g@mail.gmail.com>
Subject: Running compsize utility on btrfs compress mount point
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

This email is in context of another thread initiated by me (with
Subject: using fio to test btrfs compression).

Just as brief background, I am trying to verify btrfs compression
where I am writing data using
fio, dd or cp command.

In response to my question in another thread:
> Is there any command that i can run to confirm file has been compressed?

I've gotten response from Duncan:
>>There is the quite recently posted (and actively updated since then)
>>compsize command.

>>https://github.com/kilobyte/compsize

On running compsize on btrfs mount point created, I get following:

Type       Perc     Disk Usage   Uncompressed Referenced
Data        50%      128K         256K         256K
zlib          50%      128K         256K         256K
Data       100%       10G          10G          10G
none       100%       10G          10G          10G

but then how do I interpret above information?
if I go by each line, then Does ..

1st entry means
Data        50%      128K         256K         256K
 - It is just raw uncompressed data but occupying only 50% of disk
space w.r.t its size (may be because of its CoW or deduplication?)

zlib          50%      128K         256K         256K
- This is zlib compressed data occupying 50% of disk usage ?

Data       100%       10G          10G          10G
- This is uncompressed data with no compression/cow/deduplication
occupying 100% of disk of its size?

none       100%       10G          10G          10G
- Did not understand how to interpret none entry here.. any help?

Thanks
Shally
