Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:46962 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdJLAsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 20:48:03 -0400
Received: by mail-pf0-f178.google.com with SMTP id p87so2639884pfj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 17:48:03 -0700 (PDT)
Received: from olive.ig.local ([71.68.150.33])
        by smtp.gmail.com with ESMTPSA id h1sm21654414pgp.37.2017.10.11.17.48.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Oct 2017 17:48:01 -0700 (PDT)
Date: Wed, 11 Oct 2017 20:47:59 -0400
From: Joseph Dunn <jdunn14@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs seed question
Message-ID: <20171011204759.1848abd7@olive.ig.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After seeing how btrfs seeds work I wondered if it was possible to push
specific files from the seed to the rw device.  I know that removing
the seed device will flush all the contents over to the rw device, but
what about flushing individual files on demand?

I found that opening a file, reading the contents, seeking back to 0,
and writing out the contents does what I want, but I was hoping for a
bit less of a hack.

Is there maybe an ioctl or something else that might trigger a similar
action?

Thanks,
-Joseph
