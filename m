Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40037 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2KQCw6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 21:52:58 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so1698297wgb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2012 18:52:57 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 10:52:56 +0800
Message-ID: <CAA+Oeuv=VthbT9HkEJm5REiNmOPSL0pPtV=gu4PXP1w1tM284A@mail.gmail.com>
Subject: How to remove btrfs information
From: Yangtse Su <yangtsesu@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have an btrfs part on /dev/sda5,Then I install windows8 with the
windows8 installer.I remove this btrfs part and install windows8 on
it.Now in my Linux,'btfrs filesystem show' still show /dev/sda5 as a
btrfs part. but now it is Microsoft Reserved part,only 128MB.

Here is some information:
http://paste.ubuntu.org.cn/155508


--
God Is Not A Girl!!!
