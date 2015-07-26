Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36642 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbbGZUjO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jul 2015 16:39:14 -0400
Received: by wicgb10 with SMTP id gb10so86869929wic.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 13:39:13 -0700 (PDT)
Received: from [10.0.2.15] (p3E9EE1AE.dip0.t-ipconnect.de. [62.158.225.174])
        by smtp.googlemail.com with ESMTPSA id x6sm9934305wiy.6.2015.07.26.13.39.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2015 13:39:12 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: =?UTF-8?Q?Re:_systemd_:_Timed_out_waiting_for_defice_dev-disk-by?=
 =?UTF-8?B?4oCm?=
To: linux-btrfs@vger.kernel.org
References: <1437763277.673610371@apps.rackspace.com>
Message-ID: <55B54568.5060902@googlemail.com>
Date: Sun, 26 Jul 2015 22:39:04 +0200
MIME-Version: 1.0
In-Reply-To: <1437763277.673610371@apps.rackspace.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> 50% of the time when booting, the system go in safe mode because my 12x 4TB RAID10 btrfs is taking too long to mount from fstab.

This won't help, but I've seen this exact behavior too (some time ago).
Except that it wasn't 50% that it didn't work, more like almost everytime.
Commenting out the fstab entry "fixed" it, mounting using a cronjob 
(@reboot) worked without a problem.

(As far as I remember, options like x-systemd.device-timeout didn't 
change anything.)

If someone has the answer, I'd be interested too.


Philip
