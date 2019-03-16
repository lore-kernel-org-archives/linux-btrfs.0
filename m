Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547CCC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 15:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA71A2075C
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 15:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="NcELeFYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfCPPiP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:38:15 -0400
Received: from mail.virtall.com ([46.4.129.203]:39190 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbfCPPiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 11:38:15 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Mar 2019 11:38:14 EDT
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id C3955E50C69
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2019 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1552750319; bh=2uQZsoCMSbZPiFExEKxhjeCbeo7IlJ6EzbIFL/yRDx0=;
        h=Date:From:To:Subject;
        b=NcELeFYjfj3EQI0bZdKyfXxyzQ7K1FazOLoeAW521DQ9kyl68ShVDnsfUwwlYyilR
         SkQtVpPPgzqcjids3/TNpp8jIzcRvtPbzcozy91HBJ35z66ZxKHSo4D+gOyLrjFQ79
         n+KAEF03uWu80eZPNvbnKpUEof3hQ0/d1ZYgTDmVhi5s7Vdz5U0TcwgajhbkDR+b0y
         Dl0GCGrsTzCBLEqqK4SyvTTg6YxBwV+ITGQe3zn5ga6+akdLxuxO0p6BaTSYvXc9Tw
         MytVhZ0eO+dln/RkihFdp4gJZPra4kNRjEKXoNZ2cbycHK1uau8WimHGdfHtfcspaV
         6Ej9QxKHXmxAQ==
X-Fuglu-Suspect: 3cf3b932f04b45508311d2e96e4ef497
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2019 15:31:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 17 Mar 2019 00:31:56 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: BTRFS partition over a SSD got totally broken on Ubuntu 18.10 ->
 errno=-17 Object already exists (Fa
Message-ID: <9f6444df6d5dabc0be4950d7b74aaf88@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> I have a BTRFS partititon on a Toshiba TR200 SSD . Two days ago, it
> got to readonly mode. Inspecting the dmesg I got this :

> Linux blackbox-linux 4.16.2-041602-generic #201804121130 SMP Thu Apr

btrfs, while improved a lot in the past years, still hits some issues, 
though it depends on the usage case and the kernel. Many people, 
including me, run it without and data consistency issues for years on 
many servers.

As mentioned before - a lot of depends on the kernel in use. Your kernel 
is 4.16.x, which, by btrfs standards, is quite old and outdated.

Ubuntu makes it easy to use a newer kernel:

https://kernel.ubuntu.com/~kernel-ppa/mainline/

While for systems without btrfs I'd rather stick with a distribution 
kernel, for systems with btrfs - I'd typically use a ppa kernel from 
above.


Tomasz Chmielewski
https://lxadm.com
