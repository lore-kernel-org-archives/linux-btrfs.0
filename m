Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [138.197.202.146] ([138.197.202.146]:40868 "EHLO
        WebServer.dk0.us" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751367AbdISSvG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 14:51:06 -0400
Received: from mail.dkudriavtsev.xyz (unknown [IPv6:2604:a880:2:d0::441:3001])
        by WebServer.dk0.us (Postfix) with ESMTPSA id 8764BDFC63
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:44:45 -0700 (PDT)
Mime-Version: 1.0
Date: Tue, 19 Sep 2017 18:44:45 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <dea6077b6d50c862297637c4371bede0@mail.dkudriavtsev.xyz>
From: "Dmitry Kudriavtsev" <me@dk0.us>
Subject: How to recover failing filesystem?
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My btrfs filesystem is constantly remounting itself read-only. Relevant log segments: https://hastebin.com/uyegipadex.log https://hastebin.com/wakihobivi.log

How do I fix these errors?


Thank you,
Dmitry Kudriavtsev

⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣰⣿⣿⣆⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣀⡙⠿⣿⣿⣆⠀⠀⠀⠀⠀Hey, did you hear about that cool new OS? It's called
⠀⠀⠀⠀⣰⣿⣿⣷⣿⣿⣿⣆⠀⠀⠀⠀Arch Linux. I use Arch Linux. Have you ever used Arch
⠀⠀⠀⣰⣿⣿⣿⡿⢿⣿⣿⣿⣆⠀⠀⠀Linux? You should use Arch Linux. Everyone uses Arch!
⠀⠀⣰⣿⣿⣿⡏⠀⠀⢹⣿⣿⠿⡆⠀⠀Check out i3wm too!
⠀⣰⣿⣿⣿⡿⠇⠀⠀⠸⢿⣿⣷⣦⣄⠀
⣼⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⣦
