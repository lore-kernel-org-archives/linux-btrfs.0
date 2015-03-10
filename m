Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59558 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbbCJHxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 03:53:05 -0400
Message-ID: <1425973982.20782.1.camel@gmx.de>
Subject: Re: Lock-ups, assertion failure in btrfsck, scrub reporting super=4
From: Tobias Getzner <tobias.getzner@gmx.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 10 Mar 2015 08:53:02 +0100
In-Reply-To: <CAJCQCtRkDbsYHGZ4ZmzSa99W5L-BfsDF1jE6YmqiMAxJUT+pbQ@mail.gmail.com>
References: <1425556080.32673.11.camel@gmx.de>
	 <pan$387dc$a5a9554$54f0b365$e45c3f38@cox.net>
	 <1425905102.1178.27.camel@gmx.de>
	 <CAJCQCtRkDbsYHGZ4ZmzSa99W5L-BfsDF1jE6YmqiMAxJUT+pbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mo, 2015-03-09 at 10:44 -0600, Chris Murphy wrote:
> Maybe try btrfs-progs-3.19rc3? You have the data backed up, and progs
> 3.18.2 fails so it seems worth a shot.

This was worth a shot; 3.19-rc3 throws the same assertion failure,
though.


