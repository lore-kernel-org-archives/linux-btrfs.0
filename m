Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36347 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbbIIWqy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 18:46:54 -0400
Received: by vkfp126 with SMTP id p126so575884vkf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 15:46:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Sep 2015 16:46:53 -0600
Message-ID: <CAJCQCtSWPJvRiRj9OaooOOD=kBPck1-67Z7pB1M7=wYOVCgf=A@mail.gmail.com>
Subject: kernel 4.2.0, bogus 'no space left on device' with 'btrfs delete
 missing' raid5
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bogus 'no space left on device' with 'btrfs delete missing' raid5
https://bugzilla.kernel.org/show_bug.cgi?id=104361

Summary: 4x 8GB virtual disks in raid5 with 3.62GiB data, no snapshots
or subvolumes or reflinks; fail one of the devices; reboot; btrfs dev
delete missing fails with 'no space left on device' error even though
3 remaining disks have enough space for this fs shrink.


-- 
Chris Murphy
