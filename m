Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34310 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcCAQTf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:19:35 -0500
Received: by mail-yk0-f169.google.com with SMTP id u9so79142671ykd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 08:19:34 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Mar 2016 11:19:34 -0500
Message-ID: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
Subject: btrfs raid
From: Carlos Ortega <carlos.omicron.ortega@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd like to confirm that btrfs raid actually works.  My filesystem
looks like it's a simple concatenation judging from its size in df -k
output.  btrfs filesystem df says it's a raid10, I just don't
completely trust it.  Also I'm stuck at version 3.19.1, I can't go
higher.

Can someone confirm that raid works in this version?  If so which
levels of raid?  I'd prefer raid5 or raid6.

Thanks
