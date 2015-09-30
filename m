Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:46130
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbbI3ISl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 04:18:41 -0400
Subject: Re: [PATCH] btrfs: fix a compiler warning of may be used
 uninitialized
To: Zhao Lei <zhaolei@cn.fujitsu.com>, dsterba@suse.cz
References: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com>
 <20150929142134.GC11442@twin.jikos.cz>
 <00d701d0fb33$cfbc6a80$6f353f80$@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <560B9ADF.3050503@googlemail.com>
Date: Wed, 30 Sep 2015 10:18:39 +0200
MIME-Version: 1.0
In-Reply-To: <00d701d0fb33$cfbc6a80$6f353f80$@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/15 05:55, Zhao Lei wrote:
>> count is defined iff add_to_ctl == true, so the patch is not necessary. And I'm
>> not quite sure that 0 passed down to __btrfs_add_free_space as 'bytes' makes
>> sense at all.
> 
> Agree above all.
> 
> So I write following description in changelog:
>   "Not real problem, just avoid warning of: ..."
> 
> It is just to avoid complier warning, no function changed.
> A warning in compiler output is not pretty:)

This looks more like a false-positive with gcc 4.8.3.
With 5.2:

..
  CC [M]  fs/btrfs/file-item.o
  CC [M]  fs/btrfs/inode-item.o
  CC [M]  fs/btrfs/inode-map.o
  CC [M]  fs/btrfs/disk-io.o
  CC [M]  fs/btrfs/transaction.o
..

No warning, as expected.

-h

