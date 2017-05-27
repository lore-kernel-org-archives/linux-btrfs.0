Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57861 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdE0Tgl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 15:36:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dEhVq-0005Ps-6r
        for linux-btrfs@vger.kernel.org; Sat, 27 May 2017 21:36:34 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
Date: Sat, 27 May 2017 09:36:29 -1000
Message-ID: <ogckfp$jle$1@blaine.gmane.org>
References: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 27/05/2017 à 08:53, Ivan P a écrit :
> Hello,
> 
> for a while now, btrfs-cleaner has been molesting my system's btrfs partition,
> as well as my CPU. The behavior is as following:
> 
> After booting, nothing relevant is happening. After about 5-30 minutes,
> a btrfs-cleaner process is spawned, which is constantly using one CPU core.
> The btrfs-cleaner process never seems to finish (I've let it waste CPU cycles
> for 9 hours) and also cannot be stopped or killed.

I have seen the exact same behaviour with older kernels (4.4, 4.7, 4.9),
see http://www.spinics.net/lists/linux-btrfs/msg58111.html

It seems to be related to autodefrag, rebooting without autodefrag,
manually defragmenting, and rebooting again with autodefrag worked for me.


Thanks,
-- 
Jean-Denis Girard

SysNux                  Systèmes    Linux    en  Polynésie  française
http://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.79.75.27

