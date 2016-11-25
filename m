Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:42020 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbcKYLRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 06:17:15 -0500
Date: Fri, 25 Nov 2016 16:17:12 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?TmljY29sw7I=?= Belli <darkbasic@linuxsystems.it>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: My system mounts the wrong btrfs partition, from the wrong
 disk!
Message-ID: <20161125161712.1df4f7b6@natsu>
In-Reply-To: <a39949b5-abab-40a3-943e-818b6ca7106b@linuxsystems.it>
References: <a39949b5-abab-40a3-943e-818b6ca7106b@linuxsystems.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Nov 2016 12:05:57 +0100
Niccolò Belli <darkbasic@linuxsystems.it> wrote:

> This is something pretty unbelievable, so I had to repeat it several times 
> before finding the courage to actually post it to the mailing list :)
> 
> After dozens of data loss I don't trust my btrfs partition that much, so I 
> make a backup copy with dd weekly.

https://btrfs.wiki.kernel.org/index.php/Gotchas#Block-level_copies_of_devices

"don't make copies with dd."

-- 
With respect,
Roman
