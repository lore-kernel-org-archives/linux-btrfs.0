Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34440 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756628AbcHYHXb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 03:23:31 -0400
Received: by mail-oi0-f44.google.com with SMTP id l203so55918095oib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 00:23:31 -0700 (PDT)
MIME-Version: 1.0
From: Gareth Pye <gareth@cerberos.id.au>
Date: Thu, 25 Aug 2016 17:23:25 +1000
Message-ID: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
Subject: Recommendation on raid5 drive error resolution
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I've been living on the reckless-side (meta RAID6, data RAID5) and
I have a drive or two that isn't playing nicely any more.

dmesg of the system running for a few minutes: http://pastebin.com/9pHBRQVe

Everything of value is backed up, but I'd rather keep data than
download it all again. When I only saw one disk having troubles I was
concerned. Now I notice both sda and sdc having issues I'm thinking I
might be about to have a bad time.

What else should I provide?

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
