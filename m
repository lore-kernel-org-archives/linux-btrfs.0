Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:56346 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdISVfZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 17:35:25 -0400
Received: from mail.tol.fr (unknown [IPv6:2a01:e34:eeaf:c5f0:428d:5cff:fee6:854e])
        by smtp2-g21.free.fr (Postfix) with ESMTP id 13786200398
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 23:35:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 5655697804F8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 23:35:13 +0200 (CEST)
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LMlO97iSt1SE for <linux-btrfs@vger.kernel.org>;
        Tue, 19 Sep 2017 23:35:12 +0200 (CEST)
Received: from [IPv6:2a01:e34:eeaf:c5f0:757a:e408:d24a:399e] (unknown [IPv6:2a01:e34:eeaf:c5f0:757a:e408:d24a:399e])
        by mail.tol.fr (Postfix) with ESMTPSA id CE41C97804F7
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 23:35:12 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Pierre Couderc <pierre@couderc.eu>
Subject: Problems with debian install
Message-ID: <055f00d8-4910-64eb-ea60-58b41815f2d8@couderc.eu>
Date: Tue, 19 Sep 2017 23:35:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to install stretch on a computer with 2 btrfs disks and EFI.

Is there a howto to do that ? Did someone success ?

I get problems as soon as the partionning in debian installer. What 
partitions do I need ? I understand the grub needs them even if btrfs 
does not require them. But I am lost, I think due to EFI...

I see nothing on that in google.

Thnaks

PC

