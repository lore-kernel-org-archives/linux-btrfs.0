Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35169 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbDGJ5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 05:57:25 -0400
Received: by labbd9 with SMTP id bd9so26617984lab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 02:57:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Apr 2015 11:57:23 +0200
Message-ID: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
Subject: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I plan to install my OS on a btrfs partition, with some subvolumes.
Once the partition has been btrfs formated, I mounted it somewhere, cd
and then run <btrfs subvolume create>.

I did these two subvolumes for now:
# btrfs subvolume list .
ID 256 gen 6 top level 5 path var
ID 257 gen 7 top level 5 path home

Now I am wondering if I need to create the root filesystem partition
(/)? If yes, is this correct:
# btrfs subvolume create root

Thank you for hints
-- 

google.com/+arnaudgabourygabx
