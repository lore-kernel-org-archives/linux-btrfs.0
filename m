Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36860 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbcAGBaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:30:15 -0500
Received: by mail-ig0-f175.google.com with SMTP id z14so23383415igp.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 17:30:15 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Jan 2016 10:30:14 +0900
Message-ID: <CAG8fp8SNjeG0npQtcYP25d8sRd++tMsuo8JvaEvYSr8ZU9UW9A@mail.gmail.com>
Subject: Re: sendfile(2) not killable on btrfs
From: Akihiro Suda <suda.kyoto@gmail.com>
To: linux-btrfs@vger.kernel.org, chris@csamuel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1857622.QQxRQMXbK2@quad>

>> However, it is still not killable on btrfs.
>
>Your bugzilla entry is for the 4.2 kernel in the current Ubuntu, but this
>patch was only merged into the mainline for at v4.3-rc6-123-g296291c so unless
>it was backported by Canonical it won't be present.
>
>Could you test with the 4.3 kernel please?
>
>http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/
>
>cheers!
>Chris

Hi,
Thank your the comment.
The patch has been backported to v4.2 by Canonical:
http://kernel.ubuntu.com/git/ubuntu/ubuntu-wily.git/commit/mm/filemap.c?id=4d291df30fb7a94d13c6d38addf8d85d38f0111b

I tried linux-image-4.3.3-040303-generic_4.3.3-040303.201512150130_amd64.deb,
and I can still hit the bug.
Should I also test the vanilla kernel?

Sorry for that this mail can break In-Reply-To header, as I'm not
subscribing the ML, and manually writing this reply.
