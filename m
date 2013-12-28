Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:65230 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3L1SBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 13:01:36 -0500
Received: by mail-ig0-f174.google.com with SMTP id hk11so32303236igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 10:01:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131228173730.GA7234@carfax.org.uk>
References: <20131228171943.GE19863@merlins.org>
	<20131228173730.GA7234@carfax.org.uk>
Date: Sat, 28 Dec 2013 20:01:35 +0200
Message-ID: <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Emil Karlson <jekarlson@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Marc MERLIN <marc@merlins.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are also silent content missmatches on some subset of files that
are not linearly written (vm images, databases and such).

https://bugzilla.kernel.org/show_bug.cgi?id=66941
