Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:36003 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757483AbcK2PS0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 10:18:26 -0500
Received: by mail-wj0-f177.google.com with SMTP id qp4so148138987wjc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 07:18:25 -0800 (PST)
Received: from [131.220.163.37] (ltfreyermuth.physik.uni-bonn.de. [131.220.163.37])
        by smtp.googlemail.com with ESMTPSA id ua15sm68272317wjb.1.2016.11.29.07.18.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Nov 2016 07:18:24 -0800 (PST)
References: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
Subject: Re: [bug] btrfs-progs-v4.8.4: test of 'btrfs receive' in xfstests
 fails
To: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <4cb0f005-6c09-37e2-8448-ab5181e47a80@googlemail.com>
Date: Tue, 29 Nov 2016 16:18:23 +0100
MIME-Version: 1.0
In-Reply-To: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

just to chime in on this: This issue also affects me as a "downstream" user, 
so it also breaks real-life usecases. 

I use btrbk for backup, and when performing a regular incremental backup,
after switching to btrfs-progs 4.8.4, I get the same "short read from stream" problem. 

Internally, btrbk issues something along the lines of:
btrfs send -p /mnt/btrfs_pool/_btrbk_snap/home.20161127T020001+0100 /mnt/btrfs_pool/_btrbk_snap/home.20161127T030001+0100 | btrfs receive /mnt/btrfs_backup/alien17/
which then exits with a non-zero return code due to the "short read from stream" issue. 

Needless to say, everything is fine again after downgrade to btrfs-progs 4.8.3. 

Cheers, 
	Oliver

PS: While I will check back for replies in the archive, a courtesy cc will be 
appreciated since I am not subscribed to the list.
