Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54603 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbAETSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 14:18:21 -0500
Received: by mail-ie0-f181.google.com with SMTP id rl12so18289772iec.12
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jan 2015 11:18:20 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 5 Jan 2015 13:18:20 -0600
Message-ID: <CAAe=sHXgd0J+rm-w4cHC-P9T=PUCRx6vmLH0U3Uyhr03EZ_r5g@mail.gmail.com>
Subject: Balance is inexplicably dieing (repeatedly)
From: "sys.syphus" <syssyphus@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I start it. I check it and its like 2% done
Several hours its stopped and the re-balance clearly didn't finish
because I can see one member of the array has a fraction of the usage
of the others. Dmesg shows no errors.

Thoughts? should start it again in the foreground with verbosity or
something? any logs i can check other than dmesg?


dmesg only shows similar to below

[342210.304169] BTRFS info (device dm-4): relocating block group ##### flags 17
[342219.191141] BTRFS info (device dm-4): found 129 extents
[342233.029425] BTRFS info (device dm-4): found 129 extents
[342235.434779] BTRFS info (device dm-4): relocating block group ##### flags 17
[342252.264736] BTRFS info (device dm-4): found 67 extents
[342266.630318] BTRFS info (device dm-4): found 67 extents
