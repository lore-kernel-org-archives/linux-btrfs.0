Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752676AbeBZIZW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:25:22 -0500
Subject: Re: Help with leaf parent key incorrect
To: Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <MEXPR01MB03427A142FC749C4C2126A0A9EC20@MEXPR01MB0342.ausprd01.prod.outlook.com>
 <d870155a-0523-d453-b302-ca5addeda67e@oracle.com>
 <ME1PR01MB0338086CF4FF5F185BA52C029EC10@ME1PR01MB0338.ausprd01.prod.outlook.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2fd186fe-34b3-c2dd-ad36-a043368104eb@oracle.com>
Date: Mon, 26 Feb 2018 16:26:43 +0800
MIME-Version: 1.0
In-Reply-To: <ME1PR01MB0338086CF4FF5F185BA52C029EC10@ME1PR01MB0338.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 > There is one io error in the log below,

Apparently, that's not a real EIO. We need to fix it.
But can't be the root cause we are looking for here.

----
 > Feb 24 22:41:59 home kernel: BTRFS: error (device dm-6) in 
btrfs_run_delayed_refs:3076: errno=-5 IO failure
 > Feb 24 22:41:59 home kernel: BTRFS info (device dm-6): forced readonly

static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
                                  struct btrfs_fs_info *fs_info,
                                  struct btrfs_delayed_ref_head *head,
                                  struct btrfs_delayed_extent_op *extent_op)
{
::

                 } else {
                         err = -EIO;
                         goto out;
                 }
----

 > but other than that I have never had io errors before, or any other 
troubles.

  Hm. btrfs dev stat shows real disk IO errors.
  As this FS isn't mountable .. pls try
   btrfs dev stat <dev> > file
   search for 'device stats', there will be one for each disk.
  Or it reports in the syslog when it happens not necessarily
  during dedupe.

 > One of my other filesystems share the same two discs and it is still 
fine, so I think the hardware is probably ok.
  Right. I guess that too. A confirmation will be better.
 > I've copied the beginning of the errors below.


  At my end finding the root cause of 'parent transid verify failed'
  during/after dedupe is is kind of fading as disk seems to be had
  no issues. which I had in mind.

  Also, there wasn't abrupt power-recycle here? I presume.

  It's better to save the output disk1-log and disk2-log as below
  before further efforts to recovery. Just in case if something
  pops out.

   btrfs in dump-super -fa disk1 > disk1-log
   btrfs in dump-tree --degraded disk1 >> disk1-log [1]

   btrfs in dump-super -fa disk2 > disk2-log
   btrfs in dump-tree --degraded disk2 >> disk2-log [1]

  [1]
   --degraded option is in the ML.
   [PATCH] btrfs-progs: dump-tree: add degraded option

Thanks, Anand
