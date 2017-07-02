Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:44114 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdGBWoQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 18:44:16 -0400
Received: from cpc82297-ando7-2-0-cust601.15-1.cable.virginm.net ([82.10.190.90]:42186 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <pete@petezilla.co.uk>)
        id 1dRmUK-000eNR-Jg
        for linux-btrfs@vger.kernel.org; Sun, 02 Jul 2017 22:33:05 +0100
To: linux-btrfs@vger.kernel.org
From: Pete <pete@petezilla.co.uk>
Subject: Deleting mounted subvolumes
Message-ID: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
Date: Sun, 2 Jul 2017 22:33:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found that I can delete a mounted subvolume using:
btrfs subvolume delete <mounted sub volume>

This works.  Is this the intended action?  To me it would seem like a
warning and the command exiting would make sense?

Pete

