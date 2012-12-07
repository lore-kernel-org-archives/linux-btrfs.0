Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51244 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab2LGNsv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 08:48:51 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so394127oag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2012 05:48:51 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Dec 2012 08:48:49 -0500
Message-ID: <CACR_K2ss6LSQYeeEVcxmSvpEL-fHifO0trdaBmgURCQpgJi5kQ@mail.gmail.com>
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
From: Sylvain Alain <d2racing911@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I tested the fstrim

root@sysresccd /root % time fstrim -v /mnt/gentoo
/mnt/gentoo: 8148938752 bytes were trimmed

I noticed that my btrfs hang my SSD only with small files.

I tested with removing the /usr/src/linux directory(kernel sources)
with emerge -C vanilla-sources from Gentoo and I noticed this
behaviour.

So, should I remove the discard option or not from my /etc/fstab ?

--
Salut
alp
Sylvain
