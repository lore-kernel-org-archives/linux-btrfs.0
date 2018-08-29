Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:15138 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727254AbeH2QqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 12:46:18 -0400
Received: from mail.tol.fr (unknown [78.234.252.95])
        by smtp1-g21.free.fr (Postfix) with ESMTP id E806DB00535
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 14:49:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 7A1DA97804FA
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 14:49:30 +0200 (CEST)
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id suwPf-jOp9ZI for <linux-btrfs@vger.kernel.org>;
        Wed, 29 Aug 2018 14:49:30 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id 0FE18978044E
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 14:49:30 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Pierre Couderc <pierre@couderc.eu>
Subject: How to erase a RAID1 ?
Message-ID: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
Date: Wed, 29 Aug 2018 14:49:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to reinstall a RAID1 btrfs system (wchis is now under debian 
stretch, and will be reinstalled in stretch).

How to correctly "erase" it ? Not truly hard erase it, but so that old 
data does not appear...

It is not clear in the wiki.

Thanks

PC
