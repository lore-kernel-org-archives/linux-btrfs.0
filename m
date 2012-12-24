Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63372 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2LXFKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Dec 2012 00:10:48 -0500
Received: by mail-oa0-f45.google.com with SMTP id i18so6539250oag.18
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Dec 2012 21:10:48 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Dec 2012 10:40:47 +0530
Message-ID: <CAOeZVicGa3Em4Ki7MkX5=YsHgWKqnKCeojLZNJLdVYxc1LYLfg@mail.gmail.com>
Subject: Locking in BTRFS
From: Atri Sharma <atri.jiit@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am working on reducing the lock contention in BTRFS, especially in
the cases when all writers request locks simultaneously.

I am reading the code and referencing the code documentation. Can
somebody please explain a bit about the current locking scheme that we
have? I have some confusion there.

Thanks,

Atri

--
Regards,

Atri
l'apprenant
