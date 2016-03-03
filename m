Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:34903 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbcCCXuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 18:50:11 -0500
Received: by mail-yw0-f173.google.com with SMTP id g127so31826524ywf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 15:50:10 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Mar 2016 20:50:10 -0300
Message-ID: <CACSpBpFBW=t1hyejRVxkzuauZy-18e3S4RoyCby4mUJMdtWftw@mail.gmail.com>
Subject: Byte comparison before hashing
From: Nikolai Viktorovich <nikolai.viktorovich@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First of all: Thanks for the great work on btrfs!
How about taking only few bytes of data from each block and compare
those, before attempting to hash? This way you could quickly discard
blocks with really no similar data and hash only ones that matched the
"first look" byte comparison? This could lead to less CPU consumption,
since hashing is an intense operation, and to less memory footprint,
since you don't need to store all those non-dedupable hashes.
