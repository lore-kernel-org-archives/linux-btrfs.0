Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E146C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 10:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F7C21773
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 10:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cam.ac.uk header.i=@cam.ac.uk header.b="x2YcUmKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfBSKys (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:54:48 -0500
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:37362 "EHLO
        ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfBSKys (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 05:54:48 -0500
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2019 05:54:48 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cam.ac.uk;
         s=20180806.ppsw; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1Umq5apIApfLmR0nIckXVLGhci/i1wrEbglkNxCPLIY=; b=x2YcUmKXepNifSKlzhYUYCbfdB
        AbJyWLcxs0R7wvbHsSVlbCO3/B0bfWZayDQsWmJJfkWIIezD14HJeIGp/2DbifuoXFVrtXoL/ZEpk
        zlqaIA7NM4AmMQrdd8j+/mdgciZc9n8vA7WY/e6c6BzHMOpvxDP9VKPtM6Q5jcxxigjc=;
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://help.uis.cam.ac.uk/email-scanner-virus
Received: from casxb.ast.cam.ac.uk ([131.111.68.80]:33605)
        by ppsw-32.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
        with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        id 1gw2a1-000UyM-33 (Exim 4.91) for linux-btrfs@vger.kernel.org
        (return-path <rmj@ast.cam.ac.uk>); Tue, 19 Feb 2019 10:24:50 +0000
Received: from xserv1.ast.cam.ac.uk (xserv1.ast.cam.ac.uk [131.111.69.235])
        by casxb.ast.cam.ac.uk (8.15.1+Sun/8.15.1) with ESMTP id x1JAOnAO024828
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 10:24:49 GMT
Received: from xpc16.ast.cam.ac.uk (xpc16.ast.cam.ac.uk [131.111.69.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmj@xserv1.ast.cam.ac.uk)
        by xserv1.ast.cam.ac.uk (Postfix) with ESMTPSA id 9AC1120164
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 10:24:49 +0000 (GMT)
To:     linux-btrfs@vger.kernel.org
From:   Roderick Johnstone <rmj@ast.cam.ac.uk>
Subject: Broken filesystem
Message-ID: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>
Date:   Tue, 19 Feb 2019 10:24:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi

This is on Fedora 28:

# uname -a
Linux mysystem.mydomain 4.20.7-100.fc28.x86_64 #1 SMP Wed Feb 6 19:17:09 
UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.17.1

#   btrfs fi show
Label: none  uuid: 56d0171a-440d-47ff-ad0f-f7f97df31f7b
         Total devices 1 FS bytes used 7.39TiB
         devid    1 size 9.10TiB used 7.50TiB path /dev/md2


My btrfs filesystem is in a bad state after a partial disk failure on 
the md device (raid 6 array) the file system was on.

One of the disks had bad blocks, but instead of being ejected from the 
array, the array hung up. After rebooting to regain access and remove 
the bad disk I am in the following situation:

# mount -t btrfs -o compress-force=zlib,noatime /dev/md2 /mnt/rmj
mount: /mnt/rmj: wrong fs type, bad option, bad superblock on /dev/md2, 
missing codepage or helper program, or other error.
# dmesg
...
   264.527647] BTRFS info (device md2): force zlib compression, level 3
[  264.955360] BTRFS error (device md2): parent transid verify failed on 
5568287064064 wanted 254988 found 94122
[  264.964273] BTRFS error (device md2): open_ctree failed

I can mount and access the filesystem with the usebackuproot option:

# mount -t btrfs -o usebackuproot,compress-force=zlib,noatime /dev/md2 
/mnt/rmj
[  307.542761] BTRFS info (device md2): trying to use backup root at 
mount time
[  307.542768] BTRFS info (device md2): force zlib compression, level 3
[  307.570897] BTRFS error (device md2): parent transid verify failed on 
5568287064064 wanted 254988 found 94122
[  307.570979] BTRFS error (device md2): parent transid verify failed on 
5568287064064 wanted 254988 found 94122
[  431.167149] BTRFS info (device md2): checking UUID tree

But later after a umount there are these messages.

# umount /mnt/rmj
2205.778998] BTRFS error (device md2): parent transid verify failed on 
5568276393984 wanted 254986 found 94117
[ 2205.779008] BTRFS: error (device md2) in __btrfs_free_extent:6831: 
errno=-5 IO failure
[ 2205.779082] BTRFS info (device md2): forced readonly
[ 2205.779087] BTRFS: error (device md2) in btrfs_run_delayed_refs:2978: 
errno=-5 IO failure
[ 2205.779192] BTRFS warning (device md2): btrfs_uuid_scan_kthread 
failed -30

and a subsequent mount without the userbackuproot fails in the same way 
as before.

I have a copy of the important directories, but would like to be able to 
repair the filesystem if possible,

Any advise around repairing the filesystem would be appreciated.

Thanks.

Roderick Johnstone
