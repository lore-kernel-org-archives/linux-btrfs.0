Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63985 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBJUyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 15:54:02 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so5168692lbv.5
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 12:54:00 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id l4sm17012200lbd.15.2014.02.10.12.53.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 10 Feb 2014 12:54:00 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Error: could not do orphan cleanup -22
Date: Tue, 11 Feb 2014 00:53:57 +0400
Message-ID: <2047838.eX9UXPvc1f@melforce>
In-Reply-To: <2047669.QmpNhlvBGM@melforce>
References: <2047669.QmpNhlvBGM@melforce>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some more update.
I checked the FS with btrfsck:

checking extents
ref mismatch on [17018880 8192] extent item 1, found 2
Incorrect local backref count on 17018880 root 258 owner 826 offset 0 found 2 wanted 1 back 0x961b268
backpointer mismatch on [17018880 8192]
ref mismatch on [17027072 8192] extent item 1, found 2
Incorrect local backref count on 17027072 root 258 owner 827 offset 0 found 2 wanted 1 back 0x93ce988
backpointer mismatch on [17027072 8192]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/sdb3
UUID: c3f3a649-d8c3-49e1-9962-9b3ca9f54f1d
free space inode generation (0) did not match free space cache generation (6151)
free space inode generation (0) did not match free space cache generation (6151)
found 226798495277 bytes used err is 0
total csum bytes: 619125860
total tree bytes: 1041760256
total fs tree bytes: 270155776
total extent tree bytes: 22577152
btree space waste bytes: 164080420
file data blocks allocated: 1102635630592
 referenced 634893860864
Btrfs v3.12

Is it ok to try repairing it?
