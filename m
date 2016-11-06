Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:37914
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751613AbcKFNkW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 6 Nov 2016 08:40:22 -0500
Received: from kiara-mail-exchange.vpn.wellbehavedsoftware.com (kiara-mail-exchange.vpn.wellbehavedsoftware.com [10.109.164.135])
        by mail-hub.vpn.wellbehavedsoftware.com (Postfix) with ESMTP id 8FAE6173E24
        for <linux-btrfs@vger.kernel.org>; Sun,  6 Nov 2016 13:30:53 +0000 (UTC)
Received: from [10.109.135.63] (81.184.239.202.dyn.user.ono.com [81.184.239.202])
        by kiara-mail-exchange.vpn.wellbehavedsoftware.com (Postfix) with ESMTPSA id 712F82C82F
        for <linux-btrfs@vger.kernel.org>; Sun,  6 Nov 2016 13:30:53 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@wellbehavedsoftware.com>
Subject: Announcing btrfs-dedupe
Message-ID: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
Date: Sun, 6 Nov 2016 14:30:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm pleased to announce my btrfs deduplication utility, written in Rust. 
This operates on whole files, is fast, and I believe complements the 
existing utilities (duperemove, bedup), which exist currently.

Please visit the homepage for more information:

http://btrfs-dedupe.com

James Pharaoh
