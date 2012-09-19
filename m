Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2ISXhC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 19:37:02 -0400
Received: by pbbrr13 with SMTP id rr13so3659472pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 16:37:01 -0700 (PDT)
Message-ID: <505A5715.9060309@gmail.com>
Date: Thu, 20 Sep 2012 07:36:53 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: enquiry about autodefrag option
References: <50570652.4060200@gmail.com> <5059AC5E.1030003@gmail.com> <5059D2D3.3050303@oracle.com>
In-Reply-To: <5059D2D3.3050303@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> 2. AFAIK, "autodefrag" detects small random writes into files and
>>> queues them up for an automatic defrag process, so the filesystem will
>>> defragment itself while it's used.
>>>
>>>     If the system reboot/crash/remount-ro, will the autodefrag process
>>> continue after resume?
>>>
> For reboot, autodefrag will be waited to finish during umounting btrfs.
>
> For crash and remount-ro, it won't resume since it is not that necessary and we're all
> COWed so that the data is ok.
>
> And autodefrag will only take effect when taking the 'autodefrag' mount option.
>
> thanks,
> liubo
>
>

Can the loophole be fixed by tuning the autodefrag algorithm? e.g. also queue up small extents detected during read operation for the autodefrag process.

Is there any io niceness control for autodefrag process too? it will be nice if the idle class is used.


Actually, i try to write shell script to defrag entire FS monthy. but i soon find out it is hard to keep track of progress across reboot and avoid redefragging defragged file

For me, autodefrag is a killer feature. :)

