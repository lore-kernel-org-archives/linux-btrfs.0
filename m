Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:35469 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3LWItQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 03:49:16 -0500
Received: by mail-qe0-f47.google.com with SMTP id t7so4757338qeb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Dec 2013 00:49:16 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Dec 2013 09:49:16 +0100
Message-ID: <CADbA=FVN5juGTxFZKdj_gqmJ5aGSyzikXMW9HDUAciBX1mUWzg@mail.gmail.com>
Subject: list_del corruption
From: Geert Jansen <geertj@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

myself, and some other Fedora users, are experiencing a crash in
btrfs. I am using Fedora 20 with its stock kernel (3.12.5 based). The
call trace is here:

  https://retrace.fedoraproject.org/faf/reports/226666/

I have no way to reproduce unfortunately. The crash happens about once a week.

There is also a Red Hat bugzilla here:

  https://bugzilla.redhat.com/show_bug.cgi?id=1028750

The Red Hat bugzilla contains a patch for 3.13 that is claimed to fix
the issue. However the patch does not apply cleanly, and the comment
in the patch indicate that it fixes a different, more recently
introduced bug.

Any help is appreciated.

Thanks,
Geert Jansen
