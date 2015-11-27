Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35447 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbbK0Udb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 15:33:31 -0500
Received: by lfdl133 with SMTP id l133so139248076lfd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 12:33:29 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 27 Nov 2015 22:33:29 +0200
Message-ID: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
Subject: BTRFS: could not find root 8
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After upgrading from systemd227 to 228
these messages began to show up during boot:

[   24.652118] BTRFS: could not find root 8
[   24.664742] BTRFS: could not find root 8

Are they important?

Regards,
