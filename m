Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33871 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933860AbcJUVXk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 17:23:40 -0400
Received: by mail-lf0-f47.google.com with SMTP id b81so147697333lfe.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 14:23:40 -0700 (PDT)
MIME-Version: 1.0
From: Peter Becker <floyd.net@gmail.com>
Date: Fri, 21 Oct 2016 23:23:38 +0200
Message-ID: <CAEtw4r3fGWmR_reiYh7azaVnTsv=W9CV0-GNKWTju8wP9BfWFQ@mail.gmail.com>
Subject: build error btrfs-progs 4.8.1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ uname -r
4.8.3-040803-generic

$ git remote -v
origin git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
(fetch)
origin git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
(push)

$ git pull
Already up-to-date.

$ ./autogen.sh
...
$ ./configure
...
$ make
...
make: *** Keine Regel vorhanden, um das Ziel "list.h",
   benötigt von "ctree.o", zu erstellen.  Schluss.
