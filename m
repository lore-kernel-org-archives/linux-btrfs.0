Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdIMQUi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 12:20:38 -0400
Date: Wed, 13 Sep 2017 09:20:31 -0700 (PDT)
Message-Id: <20170913.092031.2176431746672254970.davem@davemloft.net>
To: allen.lkml@gmail.com
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        target-devel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] drivers:ethernet: return -ENOMEM on allocation
 failure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1505287939-14106-6-git-send-email-allen.lkml@gmail.com>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
        <1505287939-14106-6-git-send-email-allen.lkml@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Allen Pais <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 13:02:15 +0530

> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

This is quite pointless as the caller doesn't do anything with
the value, it just tests whether a negative value is returned
or not.
