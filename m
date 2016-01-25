Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36636 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcAYAss (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 19:48:48 -0500
Received: by mail-ig0-f182.google.com with SMTP id z14so25204269igp.1
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 16:48:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$b9def$888b2261$49e72de1$f428a4c9@cox.net>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
	<pan$b9def$888b2261$49e72de1$f428a4c9@cox.net>
Date: Sun, 24 Jan 2016 17:48:48 -0700
Message-ID: <CAJCQCtR=LyBq=bSYosXq1YrEzP2-HzJXHGzL70oFhbHb1dNweQ@mail.gmail.com>
Subject: Re: uknown issues - different sha256 hash - files corruption
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

re: network induced corruption

Some hints should be possible with either

# ip link
# ip -s link show <specific link>

or

# ifconfig

It should show packet errors. Check this on both sides of the network
connection. It seems kinda unlikely to me that a lot of data can go
through two NICs, have this much corruption, and not have some
indication there are network problems.


Chris Murphy
