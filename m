Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2706BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 18:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6AAA20855
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 18:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="L3LmaoTn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6AAA20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbeKJDy7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 22:54:59 -0500
Received: from mail.virtall.com ([46.4.129.203]:37176 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbeKJDy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 22:54:59 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2018 22:54:58 EST
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 1CB793552E77
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1541786884;
        bh=9G/6EHDCjq1Z5oD6W+ZoJjS8nxuWOjaI+7uN62kYKGg=;
        h=Date:From:To:Subject;
        b=L3LmaoTng/6GrI9hOudi6cwWvkI6PMtawL8b7e+38E7EiqNpiBCM1Mp1wLorrUx9T
         EpREm4Ct77ZWEUKHrar5l57MpZaJ+2mZrqdvS40aANjo2+k21Zd8+uY4Eo9WLj/h2X
         31Fb3/h47mQhSpvuHVHlySMJwE659vmp0GDHFXwIzskILWveYqfo9Z/8J4S9uGVS7v
         AJ9zqgmFqNWf/eeXzL95PSwzJJXoOwszZjzJ6i6yqkQEcp/BwvqF6mH1xV5cSrbE0k
         VGksP9CfxSHmZgq/E8aPaicUDjL0HLCZMPX94+J/Yd/h34VWkWrYC4Rc3zw5N72iaa
         203sHVq9BJxxw==
X-Fuglu-Suspect: 91fe4fc45b9a4028b26cbff4abee614f
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 18:08:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 10 Nov 2018 03:08:01 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: unable to mount btrfs after upgrading from 4.16.1 to 4.19.1
Message-ID: <2442f641ad54ce98361cf40b70e4d18d@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs sits on md RAID-5:

/dev/md2 /data btrfs noatime,compress-force=zstd,space_cache=v2,noauto 0 
0


After upgrading from kernel 4.16.1 to 4.19.1 and a clean restart, the fs 
no longer mounts:


# mount /data
mount: wrong fs type, bad option, bad superblock on /dev/md2,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

# dmesg
[  322.877321] BTRFS info (device md2): force zstd compression, level 0
[  322.877326] BTRFS info (device md2): enabling free space tree
[  322.877329] BTRFS info (device md2): using free space tree
[  322.877330] BTRFS info (device md2): has skinny extents
[  367.832058] BTRFS error (device md2): bad tree block start, want 
21120019922944 have 620757027
[  367.832116] BTRFS error (device md2): failed to read block groups: -5
[  367.891339] BTRFS error (device md2): open_ctree failed



The error (bad tree block start) in dmesg changes every time as I re-run 
"mount /data":

[  589.425362] BTRFS error (device md2): bad tree block start, want 
22008094932992 have 3378573292323635748
[  589.425423] BTRFS error (device md2): failed to read block groups: -5
[  589.469979] BTRFS error (device md2): open_ctree failed


[  680.585908] BTRFS error (device md2): bad tree block start, want 
21058406105088 have 18446616720224032488
[  680.585991] BTRFS error (device md2): failed to read block groups: -5
[  680.625419] BTRFS error (device md2): open_ctree failed


Any advice how to recover?


Tomasz Chmielewski
https://lxadm.com
