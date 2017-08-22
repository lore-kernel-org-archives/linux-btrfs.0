Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:51160 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932222AbdHVK2k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 06:28:40 -0400
Date: Tue, 22 Aug 2017 13:28:16 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: g6094199@freenet.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable
 to find block group for 0
Message-ID: <20170822132816.1bd0a511@job>
In-Reply-To: <2bee7fc8-3724-0ade-ed7f-28cc296c0595@chefmail.de>
References: <2bee7fc8-3724-0ade-ed7f-28cc296c0595@chefmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Aug 2017 11:31:23 +0200
g6094199@freenet.de wrote:
> So 1st should be investigating why did the disk not get removed
> correctly? Btrfs dev del should remove the device corretly, right? Is
> there a bug?

It should and probably did. To check that we need to see output of 
btrfs filesystem show 
and output of 
btrfs filesystem usage <mountpoint>

If there are non-raid1 chunks then you need to do soft balance:
btrfs balance start -mconvert=raid1,soft -dconvert=raid1,soft <mountpoint>

The balance should finish very quickly as you probably have only one of
data and metadata single chunks. They appeared during writes when the
filesystem was mounted read-write in degraded mode.
