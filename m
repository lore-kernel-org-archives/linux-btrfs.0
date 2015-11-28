Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34121 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbK1VJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 16:09:16 -0500
Received: by lffu14 with SMTP id u14so159457589lff.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 13:09:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTuOFJn-nemLEumDx8Ayd-GzUa+j8TiL-Y5u+dDPFKeow@mail.gmail.com>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
	<CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
	<CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
	<CAJCQCtTuOFJn-nemLEumDx8Ayd-GzUa+j8TiL-Y5u+dDPFKeow@mail.gmail.com>
Date: Sat, 28 Nov 2015 23:09:14 +0200
Message-ID: <CAK5rZE4RS8XA9HhqMMUE-DvP_Pe+SXjKvFu0Yzv+kuC_3WP5=A@mail.gmail.com>
Subject: Re: BTRFS: could not find root 8
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's on every boot.
With systemd.log_level=debug boot parameter appended,
I could not find any meaningful operation just before the message.
The systemd journal boot dump will be in your personal mailbox shortly.
