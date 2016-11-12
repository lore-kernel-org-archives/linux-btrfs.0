Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37739 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S966411AbcKLRYT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 12:24:19 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1c5c1o-0008Dz-Op
        for linux-btrfs@vger.kernel.org; Sat, 12 Nov 2016 18:23:44 +0100
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: spinning kworker with space_cache=v2 searching for free space
Date: Sat, 12 Nov 2016 07:23:01 -1000
Message-ID: <o07j5j$ag9$1@blaine.gmane.org>
References: <c9bf6cbb-ea68-a517-3c6e-7ff4ec1a788e@profihost.ag>
 <c01a47a5-ff65-1a6e-861f-ab7782bee0ed@profihost.ag>
 <20161112021821.GC30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
 <f2c219a7-993b-64ef-4bb9-5bfe352a43b4@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <f2c219a7-993b-64ef-4bb9-5bfe352a43b4@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/11/2016 à 21:58, Stefan Priebe - Profihost AG a écrit :
>>>> I always have a kworker process endless spinning.

Not sure if it is related to your problem, but I had btrfs-cleaner stuck
at 100%, see:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg56676.html

The problem disappeared after manually defragmenting all volumes.


Regards,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

