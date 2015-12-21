Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33775 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbbLUB01 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 20:26:27 -0500
Received: by mail-ob0-f182.google.com with SMTP id pl17so1898925obc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 17:26:26 -0800 (PST)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Sun, 20 Dec 2015 19:26:07 -0600
Message-ID: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
Subject: defrag vs autodefrag
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I read an implication in a different thread that defrag and autodefrag
behave differently in that autodefrag is more snapshot friendly for
COW data.

Did I understand that correctly?  I have not been doing defrag on my
virtual machine image directory because I do use a snapshot schedule
and the way I understood things, a defrag would basically decouple the
live data from the snapshots and greatly increase utilization.

It sounded like autodefrag does not have this problem?

If that's true, is there any case where it would not be best practice
to mount with autodefrag enabled?

Thanks,
Donald
