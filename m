Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37975 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbcDDBOS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 21:14:18 -0400
Received: by mail-ig0-f172.google.com with SMTP id ui10so57776844igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 18:14:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 3 Apr 2016 19:14:17 -0600
Message-ID: <CAJCQCtRB1pvOpkjbGxHLV8SRQ5sAfvg=rGjYSS19QNw3ahC_8Q@mail.gmail.com>
Subject: [bug] btrfs fi usage crash when multiple device volume contains seed device
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=115851

Happens with kernel-4.5.0-300.fc24.x86_64 and either btrfs-progs 4.4.1 or 4.5.1.

Does not happen with seed device alone. Only starts to happen once
another device is added, whether still ro or remounting rw.


-- 
Chris Murphy
