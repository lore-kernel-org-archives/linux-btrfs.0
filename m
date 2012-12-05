Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34225 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2LEF3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2012 00:29:47 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so3958261lag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2012 21:29:46 -0800 (PST)
MIME-Version: 1.0
From: Ins <insfocus@gmail.com>
Date: Wed, 5 Dec 2012 13:29:05 +0800
Message-ID: <CAMRmmp+qQZg2_vkZ9bfLFg-AC20SGkmEo4cdCOQEs+4i1JUeDQ@mail.gmail.com>
Subject: send/receive questions
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

    The implementation of send/receive is very cool.

    But I wonder whether there are any plans to support these features
below or not,

    1. support writable subvolume

    2. can skip something to receive, for example,
         (1) only receive those commands in range [1000, ..), skip the
before 1000
         (2) only receive changes after some time, like recent 3 days.

    3. can revert one receive
        Just like the patch command does

    4. support this scene,
        When doing the receive process, if it suddently be stopped,
how to continue the receive process.

    If 2 and 3 can be supported, 4 may be easy.

    It's true there may be many errors if we skip something to receive.


--
Thanks.
-Rock
