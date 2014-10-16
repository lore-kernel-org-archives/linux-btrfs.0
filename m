Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaJPKIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 06:08:43 -0400
Date: Thu, 16 Oct 2014 12:08:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: introduce a proper structure on which
 cli will call register-device ioctl
Message-ID: <20141016100841.GZ22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413333974-25579-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413333974-25579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 08:46:14AM +0800, Anand Jain wrote:
[...]
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Thanks for the detailed changelog, the patch fixes xfstests/btrfs/006
failure, previously:

    @@ -1,6 +1,10 @@
     == QA output created by 006
     == Set filesystem label to TestLabel.006
    +ERROR: device scan failed '/dev/sdc2' - File exists
    +ERROR: device scan failed '/dev/sdc3' - File exists
     == Get filesystem label
    +ERROR: device scan failed '/dev/sdc2' - File exists
    +ERROR: device scan failed '/dev/sdc3' - File exists

though I now see another message (but haven't analyzed the cause yet):

    @@ -22,18 +22,21 @@
     <NUMDEVS> [SCRATCH_DEV].read_io_errs    <NUM>
     <NUMDEVS> [SCRATCH_DEV].write_io_errs   <NUM>
     == Show device stats by first/scratch dev
    +ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on �oh failed: No such device
     [SCRATCH_DEV].corruption_errs <NUM>
     [SCRATCH_DEV].flush_io_errs   <NUM>
     [SCRATCH_DEV].generation_errs <NUM>
