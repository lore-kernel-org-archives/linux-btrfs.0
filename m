Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35488 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdAaXkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 18:40:19 -0500
Received: by mail-qk0-f194.google.com with SMTP id u25so26064273qki.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 15:39:53 -0800 (PST)
Received: from bender.physique.usherbrooke.ca (132-210-89-166.generique.USherbrooke.ca. [132.210.89.166])
        by smtp.gmail.com with ESMTPSA id a70sm16799014qkc.1.2017.01.31.15.32.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Jan 2017 15:32:59 -0800 (PST)
From: Christian Lupien <christian.lupien@gmail.com>
Message-ID: <1485905578.6441.20.camel@gmail.com>
Subject: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
Date: Tue, 31 Jan 2017 18:32:58 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been testing btrfs send/receive. I like it.

During those tests I discovered that it is possible to access and
modify (add files, delete files ...) of the new receive snapshot during
the transfer. After the transfer it becomes readonly but it could
already have been modified.

So you can end up with a source and a destination which are not the
same. Therefore during a subsequent incremental transfers I can get
receive to crash (trying to unlink a file that is not in the parent but
should).

Is this behavior by design or will it be prevented in the future?

I can of course just not modify the subvolume during receive but is
there a way to make sure no user/program modifies it?

I can also get in the same kind of trouble by modifying a parent (after
changing its property temporarily to ro=false). send/receive is
checking that the same parent uuid is available on both sides but not
that generation has not changed. Of course in this case it requires
direct user intervention. Never changing the ro property of subvolumes
would prevent the problem. 

Again is this by design?
Otherwise I would suggest finding a way to avoid those conditions
(using the generation maybe?). There could be an override option to
allow more flexibility if needed.

Thanks
Christian	
