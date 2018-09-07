Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36045 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbeIGFc2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 01:32:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A11121161
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2018 20:54:18 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2BB4E4694
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2018 20:54:17 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Remi Gauvin <remi@georgianit.com>
Subject: Re-mounting removable btrfs on different device
Message-ID: <990de394-15d2-55f3-c5ae-bef2de734978@georgianit.com>
Date: Thu, 6 Sep 2018 20:54:17 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B67520BE919F556170BF2070"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------B67520BE919F556170BF2070
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

I'm trying to use a BTRFS filesystem on a removable drive.

The first drive drive was added to the system, it was /dev/sdb

Files were added and device unmounted without error.

But when I re-attach the drive, it becomes /dev/sdg (kernel is fussy
about re-using /dev/sdb).

btrfs fi show: output:

Label: 'Archive 01'  uuid: 221222e7-70e7-4d67-9aca-42eb134e2041
	Total devices 1 FS bytes used 515.40GiB
	devid    1 size 931.51GiB used 522.02GiB path /dev/sdg1

This causes BTRFS to fail mounting the device with the following errors:

sd 3:0:0:0: [sdg] Attached SCSI disk
blk_partition_remap: fail for partition 1
BTRFS error (device sdb1): bdev /dev/sdg1 errs: wr 0, rd 1, flush 0,
corrupt 0, gen 0
blk_partition_remap: fail for partition 1
BTRFS error (device sdb1): bdev /dev/sdg1 errs: wr 0, rd 2, flush 0,
corrupt 0, gen 0
blk_partition_remap: fail for partition 1
BTRFS error (device sdb1): bdev /dev/sdg1 errs: wr 0, rd 3, flush 0,
corrupt 0, gen 0
blk_partition_remap: fail for partition 1
BTRFS error (device sdb1): bdev /dev/sdg1 errs: wr 0, rd 4, flush 0,
corrupt 0, gen 0
ata4: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
ata4: irq_stat 0x00400040, connection status changed
ata4: SError: { HostInt PHYRdyChg 10B8B DevExch }


I've seen some patches on this list to add a btrfs device forget option,
which I presume would help with a situation like this.  Is there a way
to do that manually?

--------------B67520BE919F556170BF2070
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------B67520BE919F556170BF2070--
