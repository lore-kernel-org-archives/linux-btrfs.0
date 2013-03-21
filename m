Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:36301 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab3CUIDN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 04:03:13 -0400
Message-ID: <514ABEB8.3090104@profihost.ag>
Date: Thu, 21 Mar 2013 09:03:04 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: No space left on device (28)
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while copying a 15GB file to my btrfs volume i'm getting "No space left
on device".

Some information:

# btrfs filesystem df /mnt/
Data: total=18.14TB, used=15.05TB
System, DUP: total=8.00MB, used=1.94MB
System: total=4.00MB, used=0.00
Metadata, DUP: total=23.98GB, used=17.97GB
Metadata: total=8.00MB, used=0.00

# df -h
Filesystem             Size  Used Avail Use% Mounted on
/dev/mapper/raid54tb1   19T   16T  3,1T  84% /mnt

# btrfs fi show
Label: none  uuid: fc23c4a8-a351-4c91-96a2-ee6abeffe59a
        Total devices 1 FS bytes used 15.07TB
        devid    1 size 18.19TB used 18.19TB path /dev/dm-3

# btrfs fi balance start -dusage=5 /mnt/
Done, had to relocate 0 out of 18604 chunks

What wrong here? What is about the last 3TB?

Greets.
Stefan
