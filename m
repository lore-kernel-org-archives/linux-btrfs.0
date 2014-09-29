Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42539 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbaI2OSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 10:18:05 -0400
To: bo.li.liu@oracle.com
Subject: Re: 3.17.0-rc6 system freeze
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 29 Sep 2014 16:18:01 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <20140929141016.GA31870@localhost.localdomain>
References: <a02fcec6b3069c7d69e6453725d624e5@admin.virtall.com>
 <20140929141016.GA31870@localhost.localdomain>
Message-ID: <394df3a1d2ee7b374491dd2da1958672@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-09-29 16:10 (Mon), Liu Bo wrote:
> Hi Tomasz,
> 
> On Mon, Sep 29, 2014 at 02:00:18PM +0200, Tomasz Chmielewski wrote:
>> System froze under 3.17.0-rc6 with btrfs. It had to be hard rebooted.

> How does this happen?  A stressful write with compression?

Rsync (with --inplace - can be stressful / lead to fragmentation on 
large files which change) + snapshot + remove old snapshot, for several 
remote sources (rsync server1, snapshot, remove old snap; rsync server2, 
snapshot, remove old snap etc.).

Filesystem is RAID-1 with compress-force=zlib:

/dev/sdc1 on /mnt/lxc2 type btrfs 
(rw,noatime,compress-force=zlib,space_cache)

The last operation written to the logfile was snapshot removal.


-- 
Tomasz Chmielewski
http://www.sslrack.com

