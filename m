Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39658 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdJADaH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 23:30:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dyUx3-0000Ow-Jm
        for linux-btrfs@vger.kernel.org; Sun, 01 Oct 2017 05:29:57 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Mount error on 32 bits, ok on 64 bits
Date: Sat, 30 Sep 2017 17:29:58 -1000
Message-ID: <oqpnff$ob1$1@blaine.gmane.org>
References: <oqk7mb$gud$1@blaine.gmane.org> <oqklhq$mas$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <oqklhq$mas$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/09/2017 à 19:26, Jean-Denis Girard a écrit :
> Le 28/09/2017 à 15:29, Jean-Denis Girard a écrit :
> FWIW, kernels up to 4.12.14 are ok, and 4.13-rc1 has the same probem.
> Which patches should I try to reverse first?

The problem seems to come from commit c821e7f3 "pass bytes to
btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/): the
system is now running fine on 4.13.4 with only that patch reverted.


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

