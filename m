Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38707 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbcDQKGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 06:06:46 -0400
Received: by mail-wm0-f53.google.com with SMTP id u206so85959148wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 03:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkqsNBpvSt_2c1HT5X74MTj1yzu5c2Jtpa8b1_5AcVfGU4g@mail.gmail.com>
References: <CAFChkqsNBpvSt_2c1HT5X74MTj1yzu5c2Jtpa8b1_5AcVfGU4g@mail.gmail.com>
From: Peter Waller <peter@pdftables.com>
Date: Sun, 17 Apr 2016 11:06:05 +0100
Message-ID: <CAFChkqvNdq=TRzC38PH=KqCZxzSAmDc+vRGW4enDHPhiZ0exBA@mail.gmail.com>
Subject: Re: [ANN] fienode: compute SHA1 hash of file extents for finding CoW copies
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the same vein, I've also made
https://github.com/pwaller/sharedextents - which exits with status 0
when there are shared extents, and 1 otherwise; it also prints the
number and percentage of shared bytes.

Here it is running on the file and its reflink copy from "A BTRFS
mystery" in the previous post:

$ sharedextents x y
1142734848 / 1679605760 bytes (68.04%)
