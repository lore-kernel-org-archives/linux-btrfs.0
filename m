Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57813 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3LCR2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 12:28:16 -0500
Received: by mail-ve0-f177.google.com with SMTP id db12so10417291veb.22
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 09:28:16 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 12:28:16 -0500
Message-ID: <CALnfhZDKEs7LeTrHAk3oecJ2oOqo=VJzQqoeEy3qNB92s2CC7A@mail.gmail.com>
Subject: btrfs-cleaner leaves CPU pinned to 100%
From: Adam G <adam.gradzki@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

After a recent kernel upgrade I noticed the fans blowing at full
throttle on my laptop.

There is currently very low load on the machine and nothing out of the
ordinary has occurred to lead me to believe this is normal behavior.

Here is a link to the perf output I managed to capture

http://pastebin.com/a5cAy7Dw

Please let me know if I may be of any further assistance.

Regards,

Adam Gradzki
