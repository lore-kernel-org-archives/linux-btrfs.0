Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47508 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdI2F0m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 01:26:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dxnoi-0006ih-Pq
        for linux-btrfs@vger.kernel.org; Fri, 29 Sep 2017 07:26:28 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Mount error on 32 bits, ok on 64 bits
Date: Thu, 28 Sep 2017 19:26:24 -1000
Message-ID: <oqklhq$mas$1@blaine.gmane.org>
References: <oqk7mb$gud$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <oqk7mb$gud$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/09/2017 à 15:29, Jean-Denis Girard a écrit :
> Hi list,
> 
> I have an Alix motherboard with a SD card using btrfs running fine since
> 2010. Today, I wanted to upgrade to kernel 4.13.4 from 4.9.52 (i586). As
> always, I cross-compiled from my main system, installed on Alix, but
> boot failed while trying to mount root: "BTRFS critical (device sda1):
> unable to find logical 1740640256 length 4096".
> 
> Rebooting to 4.9.52 on the Alix works just fine. Btrfs scrub returns no
> error.

FWIW, kernels up to 4.12.14 are ok, and 4.13-rc1 has the same probem.
Which patches should I try to reverse first?


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

