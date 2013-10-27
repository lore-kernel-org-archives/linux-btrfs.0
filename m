Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64802 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3J0UJS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 16:09:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id un1so7030835pbc.33
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 13:09:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Oct 2013 04:09:18 +0800
Message-ID: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>
Subject: Total fs size does not match with the actual size of the setup
From: Lester B <b.lester011+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs setup only have one device of size 7 GiB but
when I run df, the total size shown is 15 GiB. Running
btrfs --repair displays an error "cache and super
generation don't match, space cache will be invalidated."

How can I correct the total fs size as shown in df?
