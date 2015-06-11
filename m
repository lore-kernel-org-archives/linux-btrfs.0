Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:32881 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbFKK1G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 06:27:06 -0400
Received: by labke4 with SMTP id ke4so2066610lab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 03:27:04 -0700 (PDT)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Thu, 11 Jun 2015 12:26:43 +0200
Message-ID: <CAGwxe4iRVhVamCjHBTwWTts4Nm7aa8GSVfE451Og--2aCcgk9w@mail.gmail.com>
Subject: "checksum verify failed" vs. "csum failed"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Just a question to understand my logs. Doesn't matter where these
errors come from, I just want to understand them. What is the
difference of these two message types?

> BTRFS: dm-4 checksum verify failed on 6318462353408 wanted 25D94CD6 found 8BA427D4 level 1
vs.
> BTRFS warning (device dm-4): csum failed ino 27594 off 1266679808 csum 1065556573 expected csum 0

Maybe the first one was a correctable error and the second one not?

Regards,
Tobias
