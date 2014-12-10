Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48525 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaLJWPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 17:15:18 -0500
Received: by mail-ie0-f181.google.com with SMTP id tp5so3630711ieb.40
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 14:15:17 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 10 Dec 2014 16:15:17 -0600
Message-ID: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
Subject: Balance & scrub & defrag
From: "sys.syphus" <syssyphus@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am working on a script that i can run daily that will do maintenance
on my btrfs mountpoints. is there any reason not to concurrently do
all of the above? possibly including discards as well.


also, is there anything existing currently that will do maintenance on
btrfs so i don't have to reinvent the wheel?

#!/bin/bash
btrfs filesystem defragment -r -v /media/btrfs/  &
btrfs scrub start /media/btrfs/ &
btrfs balance start /media/btrfs/ &


watch -d -n 30 "btrfs balance status /media/btrfs/; btrfs scrub status
/media/btrfs/"
