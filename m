Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39653 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751177AbeF1Bm4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 21:42:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 3796521AE5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 21:42:56 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id B83CD1025C
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 21:42:55 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Remi Gauvin <remi@georgianit.com>
Subject: Major design flaw with BTRFS Raid, temporary device drop will corrupt
 nodatacow files
Message-ID: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
Date: Wed, 27 Jun 2018 21:42:55 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9F9FF6FE4F67A82DAB2979B5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------9F9FF6FE4F67A82DAB2979B5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

There seems to be a major design flaw with BTRFS that needs to be better
documented, to avoid massive data loss.

Tested with Raid 1 on Ubuntu Kernel 4.15

The use case being tested was a Virtualbox VDI file created with
NODATACOW attribute, (as is often suggested, due to the painful
performance penalty of COW on these files.)

However, if a device is temporarily dropped (this in case, tested by
disconnecting drives.) and re-connects automatically next boot, BTRFS
does not in any way synchronize the VDI file, or have any means to know
that one of copy is out of date and bad.

The result of trying to use said VDI file is.... interestingly insane.
Scrub did not do anything to rectify the situation.



--------------9F9FF6FE4F67A82DAB2979B5
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


--------------9F9FF6FE4F67A82DAB2979B5--
