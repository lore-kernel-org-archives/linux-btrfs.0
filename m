Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33457 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3DAOwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 10:52:12 -0400
Received: by mail-ob0-f179.google.com with SMTP id un3so1943838obb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 07:52:11 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Mon, 1 Apr 2013 09:51:51 -0500
Message-ID: <CAKuK5J2kjRmoMCsAJv+tdarCkLZn0xykzfuhJ4kjxrR_5VKCGQ@mail.gmail.com>
Subject: device error stats resettable?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a device that is part of a 4-device btrfs "raid1" setup.
I had accidentally jiggled the cable for this device and it started racking
up errors (about 90,000). After fixing the cable (and a scrub), all of
the errors are fixed (woo!), but
the device still shows lots of errors. Is there a way to reset the device
error count?

I'm on 3.8.2 on openSUSE 12.3 x86_64.


--
Jon
Software Blacksmith
