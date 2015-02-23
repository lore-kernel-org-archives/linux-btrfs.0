Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:49965 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbBWPaN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 10:30:13 -0500
Received: by mail-qg0-f50.google.com with SMTP id e89so24780548qgf.9
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Feb 2015 07:30:12 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Feb 2015 16:30:12 +0100
Message-ID: <CAH4oapdbkU4y6OX8HG6MNjRaWZ1fWFO2qdOvXhupEHL1nV1kHQ@mail.gmail.com>
Subject: how does --init-csum-tree work?
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I just want to ask, how does init-csum-tree work on a raid1 two disk
setup? Does it read the blocks from both of the drives and compare
them? Or does it simply take the first disk and  generate new crc's
from all the blocks on the first disk completely ignoring the second
disk?

Thanks

Pavol
