Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35919 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbbLPAfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 19:35:07 -0500
Received: by mail-ig0-f171.google.com with SMTP id ph11so121492878igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 16:35:06 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Dec 2015 17:35:05 -0700
Message-ID: <CAJCQCtSqxANo4LHFkXdQ-Ltvkci_5EU5k39oQbhKHZGWXBPBPw@mail.gmail.com>
Subject: ERROR: did not find source subvol
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 4.2.6-301.fc23.x86_64
btrfs-progs-4.2.2-1.fc23.x86_64

This is a new one for me. Two new Btrfs volumes (one single profile,
one 2x raid1) both created with this btrfs-progs. And then

[root@f23a chrisbackup]# btrfs send everything-20150922/ | btrfs
receive /mnt/br1-500g/
At subvol everything-20150922/
At subvol everything-20150922
ERROR: did not find source subvol.

There are no kernel messages.

[root@f23a chrisbackup]# du -sh everything-20150922/
324G    everything-20150922/
[root@f23a chrisbackup]# du -sh /mnt /b

[root@f23a chrisbackup]# du -sh /mnt/br1-500g/everything-20150922/
322G    /mnt/br1-500g/everything-20150922/

HUH, looks like 2G is missing on the receive side. So it got
interrupted for some reason?

btrfs check (v4.3.1) comes up clean on the source, as does a scrub.

So should I retry with -v on the send or the receive side or both?


-- 
Chris Murphy
