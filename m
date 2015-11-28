Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35380 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbbK1T0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 14:26:16 -0500
Received: by ioc74 with SMTP id 74so138133636ioc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 11:26:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
	<CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
	<CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
Date: Sat, 28 Nov 2015 12:26:15 -0700
Message-ID: <CAJCQCtTuOFJn-nemLEumDx8Ayd-GzUa+j8TiL-Y5u+dDPFKeow@mail.gmail.com>
Subject: Re: BTRFS: could not find root 8
From: Chris Murphy <lists@colorremedies.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a btrfs that has never had quota enabled:

# btrfs qgroup show /

Results in kernel message:
[  378.103836] BTRFS: could not find root 8


Each time I issue the same command, I get another "could not find..."
message. This is rather indirect, but probably means quotas aren't
enabled, and I'd expect you get this message every boot, and that it
can be ignored.


--
Chris Murphy
