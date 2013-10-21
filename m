Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33741 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3JUUiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 16:38:20 -0400
Received: by mail-wi0-f174.google.com with SMTP id cb5so4602965wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 13:38:19 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>
Date: Mon, 21 Oct 2013 23:37:59 +0300
Message-ID: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
Subject: swapfile on btrfs, temporary solution for wiki
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list, i know what btrfs  don't support swap files.
I read arch wiki and when i reading about systemd addon for auto
create swapfile on btrfs, i invent the way, how create and using swap
file, just see following sh code:

swapfile=$(losetup -f) #free loop device
truncate -s 8G /swap   #create 8G sparse swap file
losetup $swapfile /swap #mount file to loop
mkswap  $swapfile
swapon  $swapfile

i just adding this to rc.local and this just work.
May be, add it to Wiki as temporary solution to using swap file?
(sorry for my bad english)
