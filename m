Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36560 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbJOELu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 00:11:50 -0400
Received: by wicgb1 with SMTP id gb1so254969885wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 21:11:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Oct 2015 06:11:49 +0200
Message-ID: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
Subject: BTRFS raid 5/6 status
From: audio muze <audiomuze@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I've 6 x 3TB SATA drives available with a view to consolidating long
term storage to a single raid array intended to be operational more or
less 24/7.  I've done this a few times too many and run into the
inevitable issues like waiting days to expand raid arrays whilst
running the risk of disk failure in a rebuild, inability to detect bit
rot etc. so I'd like to "future proof" as far as is economically
plausible.

I'm thinking btrfs as file system configured as raid6, yielding 12TB
useable storage, protecting against two simultaneous disk failures.
Rebuilds and/or expanding the array should be pretty quick given only
actual data blocks are written on rebuild or expansion as opposed to
traditional raid systems that write out the entire array.

Before I go down this road I'd appreciate thoughts/ suggestions/
alternatives?  Have I left anything out?  Most importantly is btrfs
raid6 now stable enough to use in this fashion?
