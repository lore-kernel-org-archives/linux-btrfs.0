Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62027 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2LAHyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2012 02:54:21 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so940766lag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 23:54:20 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 1 Dec 2012 13:24:20 +0530
Message-ID: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
Subject: Snapper snapshot comparison algorithm
From: nafisa mandliwala <nafisa.mandliwala@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I needed help with understanding the snapshot comparison algorithm
that snapper uses and its shortcomings. From reading the code, what I
understood is that it does a block by block compare. I'm not very sure
if that's the best way to go about it. Also, since the send receive
code is still in development stages, is there a scope to add more
functionality to it?
