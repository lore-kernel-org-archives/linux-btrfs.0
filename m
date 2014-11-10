Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:59836 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaKJSD1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Nov 2014 13:03:27 -0500
Received: from [10.0.0.26] ([176.198.113.127]) by smtp.web.de (mrweb003) with
 ESMTPSA (Nemesis) id 0LlWFD-1YOs9a1xdn-00bGjz for
 <linux-btrfs@vger.kernel.org>; Mon, 10 Nov 2014 19:03:25 +0100
Message-ID: <5460FDEC.1000204@web.de>
Date: Mon, 10 Nov 2014 19:03:24 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfsck crash
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I got a strangely corrupted btrfs where btrfsck seems to crash. First
try with v3.14 spit a large amount of messages
(http://pastebin.com/J1jCzhzx <http://pastebin.com/J1jCzhzx>), then a
run with v3.17 gives an Assertion failed error with other messages
(http://pastebin.com/TE6dSjgR <http://pastebin.com/TE6dSjgR>). Anyone
interested in looking into this or should I reformat this disk?

Konstantin
