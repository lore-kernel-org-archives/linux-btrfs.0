Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4609CC43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF52921872
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="PY33YCzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfADNZY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:25:24 -0500
Received: from mail.virtall.com ([46.4.129.203]:39658 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfADNZY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 08:25:24 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id D665E39321C
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1546608321;
        bh=QOJA3w+cW7G80nWBpRCKYSnB//9Y9ZdvhvYD7WPomGE=;
        h=Date:From:To:Subject;
        b=PY33YCzGoQqxADD1luZG/pQFPyx807nitzzRFCX3EX9GfiRJNcvlYpO5cntH1HeTE
         xeDkzWGgpALUXGgH/eFXqO0b22iRWL5IzfIjl3jwvzH5DCN0KMSiFa/lwMQP/vusuC
         ei7F6+EDw+i6XiNoh53YOKsZsa/hJMdwfTrlNQoLrQgeugjoH7JXhl1MgzNBbd9NmE
         bjfR4v1w2HslzRrY/6rZRmPNT27fZde7d7khfT9KdvIT8JrxpD4ukxvVx5tajd5FIU
         imWi+PlLlMNbqW4ew9XOnqIpMExD7palK4itrLWlC6PCVAhjuBzA3axLfb9cMhL0Bz
         rJDH1lydx9uuA==
X-Fuglu-Suspect: 332b6a7aa1aa4fe0bfe4203fab035156
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 13:25:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 04 Jan 2019 22:25:18 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: dedicated metadata drives?
Message-ID: <fcdfebdcb0e8d5fd291d08f844274212@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

According to btrfs wiki, some patches have been submitted to support 
metadata on different devices than data (i.e. metadata on SSD, data on 
HDD):


https://btrfs.wiki.kernel.org/index.php/Project_ideas#Dedicated_metadata_drives

    Dedicated metadata drives

    Not claimed — submitted — Not in kernel yet

    We're able to split data and metadata IO very easily. Metadata tends 
to be dominated by seeks and for many applications it makes sense to put 
the metadata onto faster SSDs.




This article (almost 2.5 years old) claims one company is already using 
either these patches or something similar:

https://lwn.net/Articles/698090/

    August 24, 2016

    To combat that, he has a set of patches to automatically put the 
Btrfs metadata on SSDs. The block layer provides information on whether 
the storage is rotational; for now, his patch assumes that if
    it is not rotational then it is fast. The patch has made a huge 
difference in the latencies and requires less flash storage (e.g. 450GB 
for 40TB filesystem) for Facebook's file workload that
    consists of a wide variety of file sizes.



Do these patches exist anywhere? I couldn't find them in the list 
archive.



Tomasz
