Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61786 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2LDB2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 20:28:03 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so1558747dak.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2012 17:28:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E53AAC14-57EF-43AD-809F-96F00945245A@gmail.com>
References: <E53AAC14-57EF-43AD-809F-96F00945245A@gmail.com>
Date: Mon, 3 Dec 2012 19:28:03 -0600
Message-ID: <CAE5mzvgQ=E5YjT2u9iFHC2zML=5Hc7rNpq-1Dd5dUw6cXd_bBw@mail.gmail.com>
Subject: Re: Can't mount luks partition after reboot
From: cwillu <cwillu@cwillu.com>
To: Travis LaDuke <travisladuke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 3, 2012 at 7:22 PM, Travis LaDuke <travisladuke@gmail.com> wrote:
> This is kind of silly, but may be salvageable...
> I made a btrfs on top of luks partition and tried it for a couple days. Then
> I made another luks partition on another drive then added and balanced that
> new drive as btrfs raid1.  A lot of time passed and the balance finished.
>
> Then I rebooted. The original partition will luksOpen, but btrfs won't mount
> it. The 2nd one is in worse shape, it won't even luksOpen.
> I haven't tried btrfsck yet. Is there something else I should try first?
> What debug info can I post?
>
> halp

"Help" ;p

Try mounting the original with -o degraded, and post the dmesg of the
attempt if it doesn't work.
