Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51422 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3LSHh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 02:37:27 -0500
Received: by mail-ob0-f174.google.com with SMTP id wn1so784167obc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 23:37:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386975433-9114-1-git-send-email-fdmanana@gmail.com>
References: <1386963698-17766-1-git-send-email-fdmanana@gmail.com>
	<1386975433-9114-1-git-send-email-fdmanana@gmail.com>
Date: Thu, 19 Dec 2013 08:37:25 +0100
Message-ID: <CAFDW0jLVu4kzY-2w700QfgBA=T-6A1XoNC9N7aiAWb80+2n49Q@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix tree mod logging
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot Filipe!

Have been testing this patch now for 5 days and it fixed this annoying
Problem since 3.11.0 on 3x NFS Servers here.
This is also a candidate that should be back ported, as it fixes crashes.
Just for Information for others here: Your previous patch,
"Btrfs: return immediately if tree log mod is not necessary"
is also needed to make it apply cleanly.

Ahmet
