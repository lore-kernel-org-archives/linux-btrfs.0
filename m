Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62597 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3LSURk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 15:17:40 -0500
Received: by mail-bk0-f54.google.com with SMTP id v16so905830bkz.27
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 12:17:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAFDW0jLVu4kzY-2w700QfgBA=T-6A1XoNC9N7aiAWb80+2n49Q@mail.gmail.com>
References: <1386963698-17766-1-git-send-email-fdmanana@gmail.com>
	<1386975433-9114-1-git-send-email-fdmanana@gmail.com>
	<CAFDW0jLVu4kzY-2w700QfgBA=T-6A1XoNC9N7aiAWb80+2n49Q@mail.gmail.com>
Date: Thu, 19 Dec 2013 20:17:39 +0000
Message-ID: <CAL3q7H6Kz6mTj8QUNLydwTCD8xWtWu8-qiygE-mF7pkH1Yowfw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix tree mod logging
From: Filipe David Manana <fdmanana@gmail.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 19, 2013 at 7:37 AM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
> Thanks a lot Filipe!
>
> Have been testing this patch now for 5 days and it fixed this annoying
> Problem since 3.11.0 on 3x NFS Servers here.
> This is also a candidate that should be back ported, as it fixes crashes.
> Just for Information for others here: Your previous patch,
> "Btrfs: return immediately if tree log mod is not necessary"
> is also needed to make it apply cleanly.

Thank you Ahmet for testing it and reporting back :)

>
> Ahmet



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
