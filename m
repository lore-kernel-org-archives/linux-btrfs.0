Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33408 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbdASSce (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 13:32:34 -0500
Received: by mail-lf0-f47.google.com with SMTP id k86so42905636lfi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 10:31:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com> <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Thu, 19 Jan 2017 20:05:39 +0200
Message-ID: <CAK5rZE4ar0t4X7q-OL3oGp8MUi+bfpcXwL3E9Bb6axRx-LVGwg@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know if it is btrfs related but I'm getting
hard freezes on 4.8.17.

So I went back to 4.8.14 (with identical .config file).
It is one of my kernels which is known to be trouble
free for a long time.

Since they are hard lock up for real, I can't provide
anything.. Does anyone experience anything like that?
