Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f48.google.com ([209.85.216.48]:41741 "EHLO
	mail-vn0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbGKHEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 03:04:39 -0400
Received: by vnbf62 with SMTP id f62so24347796vnb.8
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 00:04:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>
References: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>
Date: Fri, 10 Jul 2015 20:52:45 -0600
Message-ID: <CAJCQCtRY6v7ntt333mjiO=1qv1_CEcV_xoracE26iPRbfiPfcA@mail.gmail.com>
Subject: Re: Did btrfs filesystem defrag just make things worse?
From: Chris Murphy <lists@colorremedies.com>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is compression enabled? That's the most likely reason, filefrag gives
unreliable results when compression is enabled.

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg26127.html


Chris Murphy
