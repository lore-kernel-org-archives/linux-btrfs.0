Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49984 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab3EWLv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 07:51:59 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx1so2866800pab.41
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 04:51:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 May 2013 13:51:59 +0200
Message-ID: <CAFTPBc+Z=qK1oi4MzvpTZKB-Qttc0STDHmN2qiwpi36UgqoPhQ@mail.gmail.com>
Subject: Problem with btrfs send/receive
From: Felix Blanke <felixblanke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I was trying the new send/receive feature today but can't make it work.

These are the commands I was using:

btrfs subvol snap -r /mnt/data1/@downloads/ /mnt/data1/snapshots/testsnap
btrfs send /mnt/data1/snapshots/testsnap | btrfs receive
/mnt/data1/snapshots/testreceive/

This command never finishes. A 'ls /mnt/data1/snapshots/testreceive/ '
never finishes too. After killing the send/receive process one can see
that the target subvolume was created but is empty.


Sending the snapshot to a file and use this for receiving does work.
What am I missing?


Kind regards,
Felix
