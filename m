Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:36029 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbbCIQoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 12:44:07 -0400
Received: by ykp9 with SMTP id 9so4052435ykp.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Mar 2015 09:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425905102.1178.27.camel@gmx.de>
References: <1425556080.32673.11.camel@gmx.de>
	<pan$387dc$a5a9554$54f0b365$e45c3f38@cox.net>
	<1425905102.1178.27.camel@gmx.de>
Date: Mon, 9 Mar 2015 10:44:06 -0600
Message-ID: <CAJCQCtRkDbsYHGZ4ZmzSa99W5L-BfsDF1jE6YmqiMAxJUT+pbQ@mail.gmail.com>
Subject: Re: Lock-ups, assertion failure in btrfsck, scrub reporting super=4
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe try btrfs-progs-3.19rc3? You have the data backed up, and progs
3.18.2 fails so it seems worth a shot.


Chris Murphy
