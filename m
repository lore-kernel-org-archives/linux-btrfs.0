Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:49278 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423Ab3DGLze (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 07:55:34 -0400
Received: by mail-we0-f175.google.com with SMTP id t11so3878031wey.20
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 04:55:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEct+bDZi1rzOPOL_Zeoi=fEPsyAen67OJ+t71K8VZy8BLYvVw@mail.gmail.com>
References: <CAEct+bDZi1rzOPOL_Zeoi=fEPsyAen67OJ+t71K8VZy8BLYvVw@mail.gmail.com>
Date: Sun, 7 Apr 2013 13:55:33 +0200
Message-ID: <CAEct+bA0sFqjv3AT7Oj+pfSQJyCOpkgH+cipY71E-TVsRi7Trg@mail.gmail.com>
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction
From: Kurt Huwig <kurthuwig@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got the same message. I accidentially reduced the size of a LVM
volume from 700G to 1G instead of increasing it to 1T. dmesg output
can be found here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1164336

I have it reproducible, so I can test any patches.

Kurt
