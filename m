Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33790 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbHQDfY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 23:35:24 -0400
Received: by qged69 with SMTP id d69so85937144qge.0
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2015 20:35:24 -0700 (PDT)
Received: from [192.168.0.10] (cpe-66-57-40-30.nc.res.rr.com. [66.57.40.30])
        by smtp.googlemail.com with ESMTPSA id p69sm7644090qkh.10.2015.08.16.20.35.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2015 20:35:22 -0700 (PDT)
From: Tyler Bletsch <tyler.bletsch@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs is amazing! (a lack-of-bug report)
Message-ID: <55D1567B.3030809@gmail.com>
Date: Sun, 16 Aug 2015 23:35:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just wanted to drop you guys a line to say that I am stunned with how 
excellent btrfs is. I did some testing, and the things that it did were 
amazing. I took a 4-disk RAID 5 and walked it all the way down to a 
one-disk volume and back again, mixed in devices of different sizes in 
different modes, balanced it in every direction, trashed data on drives 
without the OS knowing, and did every other form of torture I could 
think of, all while looping file integrity tests, and it was perfect.

The ease of use and simplicity were great.  I was dreading having to 
administer ZFS in order to get snapshots and other features, but now I 
don't have to. With the exception of enterprisey features like SSD 
intent logs and stuff, it is hands down far better than ZFS.

Thanks for the great work!

Regards,
Tyler Bletsch
