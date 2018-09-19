Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39529 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731532AbeISRhp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 13:37:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 306B321B25
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 08:00:09 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3FBDE493A
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 08:00:08 -0400 (EDT)
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <7db0a826-8361-2cd3-c9c3-67ea81e45db2@georgianit.com>
Date: Wed, 19 Sep 2018 08:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <e0f21dace16885d1bd615dd723235d57@virtall.com>
Content-Type: multipart/mixed;
 boundary="------------27BBD4E7275645FC9A44F05E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------27BBD4E7275645FC9A44F05E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-09-19 04:43 AM, Tomasz Chmielewski wrote:
> I have a mysql slave which writes to a RAID-1 btrfs filesystem (with
> 4.17.14 kernel) on 3 x ~1.9 TB SSD disks; filesystem is around 40% full.
> 
> The slave receives around 0.5-1 MB/s of data from the master over the
> network, which is then saved to MySQL's relay log and executed. In ideal
> conditions (i.e. no filesystem overhead) we should expect some 1-3 MB/s
> of data written to disk.
> 
> MySQL directory and files in it are chattr +C (since the directory was
> created, so all files are really +C); there are no snapshots.

Not related to the issue you are reporting, but I thought it's worth
mentioning, (since not many do), that using chattr +C on a BTRFS Raid 1
is a dangerous thing.  without COW, the 2 copies are never synchronized,
even if a scrub is executed.  So any kind of unclean shutdown that
interrupts writes (not to mention the extreme of a temporarily
disconnected drive.) will result in files that are inconsistent.  (ie,
depending on which disk happens to read at the time, the data will be
different on each read.)



--------------27BBD4E7275645FC9A44F05E
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: 7bit
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


--------------27BBD4E7275645FC9A44F05E--
