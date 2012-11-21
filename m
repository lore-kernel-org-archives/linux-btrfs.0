Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:46292 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2KUPsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 10:48:10 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2938601lag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2012 07:48:08 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 21 Nov 2012 10:48:08 -0500
Message-ID: <CAAdM647=qHnkfk=3c2hhGk61_-Jge02yxbj6nNVAqmEf+BJA-g@mail.gmail.com>
Subject: per-file NOCOW in 3.7
From: Marios Titas <redneb8888@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to the tentative changelog in the wiki, 3.7 will properly
support per-file NOCOW. I think this is misleading. In particular, it
still does not work correctly in the case when the NOCOW flag of a new
flag is being inherited from the directory. I think it would be better
to remove that item from the changelog until the the fix [1] is
merged.

[1] https://patchwork.kernel.org/patch/1438431/
