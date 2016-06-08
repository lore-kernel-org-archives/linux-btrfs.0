Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36333 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbcFHIgh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 04:36:37 -0400
Received: by mail-pf0-f171.google.com with SMTP id t190so475709pfb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jun 2016 01:36:37 -0700 (PDT)
Received: from localhost ([45.32.9.220])
        by smtp.gmail.com with ESMTPSA id f187sm302333pfb.60.2016.06.08.01.36.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jun 2016 01:36:35 -0700 (PDT)
Date: Wed, 8 Jun 2016 08:37:57 +0000
From: cdlscpmv <cdlscpmv@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Can't remove read-only snapshot with immutable flag set
Message-ID: <20160608083757.GA30823@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

It happened that I set the immutable flag (via `chattr +i`) on a subvolume.
Then I made a read-only snapshot of that subvolume. Now I can't remove
this snapshot.
	
	#> btrfs subvolume delete my_snapshot
	Delete subvolume (no-commit): 'my_snapshot'
	ERROR: cannot delete 'my_snapshot': Operation not permitted
	#> chattr -i my_snapshot 
	chattr: Read-only file system while setting flags on my_snapshot
	#> btrfs --version
	btrfs-progs v4.4.1
	#> uname -r
	4.5.2

Is there any other way to do this? Or is it a bug?

