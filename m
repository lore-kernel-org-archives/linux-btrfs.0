Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54208 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdJBSAQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 14:00:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dz50g-0006ho-Gd
        for linux-btrfs@vger.kernel.org; Mon, 02 Oct 2017 20:00:06 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Mount error on 32 bits, ok on 64 bits
Date: Mon, 2 Oct 2017 07:59:56 -1000
Message-ID: <oqtuql$k3j$1@blaine.gmane.org>
References: <oqk7mb$gud$1@blaine.gmane.org> <oqklhq$mas$1@blaine.gmane.org>
 <oqpnff$ob1$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <oqpnff$ob1$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 30/09/2017 à 17:29, Jean-Denis Girard a écrit :
> Le 28/09/2017 à 19:26, Jean-Denis Girard a écrit :
> The problem seems to come from commit c821e7f3 "pass bytes to
> btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/): the
> system is now running fine on 4.13.4 with only that patch reverted.

Same situation with 4.14-rc3: my system cannot mount root file-system.
If I revert the patch, the system boots normally. This is 100%
reproducible. How can I help resolve that issue?


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


