Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:64203 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLOib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 09:38:31 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so7074059lab.37
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 06:38:29 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id th3sm24079351lbb.11.2014.02.12.06.38.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 12 Feb 2014 06:38:28 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Error: could not do orphan cleanup -22
Date: Wed, 12 Feb 2014 18:38:26 +0400
Message-ID: <1928972.8tGm4hVmjn@melforce>
In-Reply-To: <2426118.ZFJLMUnzLe@melforce>
References: <2047669.QmpNhlvBGM@melforce> <52F94104.4030201@fb.com> <2426118.ZFJLMUnzLe@melforce>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 12 February 2014 11:32:30 Pavel Volkov wrote:
> On Monday 10 February 2014 16:13:40 Josef Bacik wrote:
> > Build a kernel with this patch applied
> > 
> > http://ur1.ca/glslj
> > 
> > and re-run the mount and when it fails attach dmesg to this email. 
> > Thanks,
> > 
> > Josef
> 
> Now I re-created the filesystem and have the error again.
> Attaching dmesg with patch.
> The last error happened when I tried to create a snapshot (from a cron
> script).

And I'll add some later messages messages from the same boot.
This time inode 153006 unlinked successfully:

 2月 12 11:37:44 melforce kernel: found orphan item for inode 88407, last_objectid 0
 2月 12 11:37:44 melforce kernel: unlink is happening
 2月 12 11:37:44 melforce kernel: found orphan item for inode 88407, last_objectid 88407
 2月 12 11:37:44 melforce kernel: BTRFS error (device sdb3): Error removing orphan entry, stopping orphan cleanup
 2月 12 11:37:44 melforce kernel: BTRFS critical (device sdb3): could not do orphan cleanup -22
 2月 12 11:38:57 melforce kernel: found orphan item for inode 155269, last_objectid 0
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 153006, last_objectid 155269
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152927, last_objectid 153006
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152926, last_objectid 152927
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152385, last_objectid 152926
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152384, last_objectid 152385
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152377, last_objectid 152384
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152373, last_objectid 152377
 2月 12 11:38:58 melforce kernel: unlink is happening
 2月 12 11:38:58 melforce kernel: found orphan item for inode 152372, last_objectid 152373
 2月 12 11:38:58 melforce kernel: unlink is happening
