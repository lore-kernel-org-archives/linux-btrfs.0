Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34754 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdH1Dne (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Aug 2017 23:43:34 -0400
Received: by mail-lf0-f41.google.com with SMTP id d17so17268480lfe.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Aug 2017 20:43:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503854146.5155.2.camel@scientia.net>
References: <1503854146.5155.2.camel@scientia.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 28 Aug 2017 05:43:16 +0200
Message-ID: <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
Subject: Re: deleted subvols don't go away?
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ID=5 is the default, "root" or "toplevel" subvolume which can't be
deleted anyway (at least normally, I am not sure if some debug-magic
can achieve that).
I just checked this (out of curiosity) and all my Btrfs filesystems
report something very similar to yours (I thought DELETED was a made
up example but I see it was literal...):

~ # btrfs sub list -a /
ID 303 gen 172881 top level 5 path <FS_TREE>/gentoo
~ # btrfs sub list -ad /
ID 5 gen 172564 top level 0 path <FS_TREE>/DELETED

I guess this entry is some placeholder, like a hidden "trash"
directory on some filesystems. I don't think this means all Btrfs
filesystems forever hold on to their last deleted subvolumes (and only
one).
