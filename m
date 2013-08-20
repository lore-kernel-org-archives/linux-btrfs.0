Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46468 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3HTNuT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 09:50:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 568597C0403
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 07:50:19 -0600 (MDT)
Date: Tue, 20 Aug 2013 09:50:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673 V2
Message-ID: <20130820135017.GE3990@localhost.localdomain>
References: <1376945597-2202-1-git-send-email-jbacik@fusionio.com>
 <5213338D.3000205@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5213338D.3000205@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 20, 2013 at 11:14:53AM +0200, Stefan Behrens wrote:
> On Mon, 19 Aug 2013 16:53:17 -0400, Josef Bacik wrote:
> > There was a problem with send trying to overwrite a file that wasn't actually
> > the same.  This is a test to check this particular case where receive fails when
> > it should succeed properly.  I tested this to verify it fails without my fix and
> > passes with my fix.  Thanks,
> 
> I tested this xfstest but for me it passes with and without the fix
> ("Btrfs: check our parent dir when doing a compare send").
>

Try again, I just tested myself and got

[root@destiny xfstests-dev]# cat /root/xfstests-dev/results//btrfs/010.full
Create subvolume '/mnt/btrfs-test/send_temp_010/send'
Create a readonly snapshot of '/mnt/btrfs-test/send_temp_010/send' in
'/mnt/btrfs-test/send_temp_010/snap1'
At subvol /mnt/btrfs-test/send_temp_010/snap1
At subvol snap1
Create a readonly snapshot of '/mnt/btrfs-test/send_temp_010/send' in
'/mnt/btrfs-test/send_temp_010/snap2'
At subvol /mnt/btrfs-test/send_temp_010/snap2
At snapshot snap2
ERROR: rename test/foo -> o260-953-0 failed. No such file or directory
failed second receive

Thanks,

Josef 
