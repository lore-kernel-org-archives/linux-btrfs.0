Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62278 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422709AbaJ3XGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 19:06:55 -0400
Received: by mail-wi0-f179.google.com with SMTP id h11so8718679wiw.12
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 16:06:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Oct 2014 18:06:54 -0500
Message-ID: <CAAKzf7=u51=1zTBoXRt0-y1ZCnPegjkX3pUPcVTXf=DSQbbKJA@mail.gmail.com>
Subject: 3.17.2 kernel patches for btrfs
From: Tim Cuthbertson <ratcheer@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does the new Linux 3.17.2 kernel have sufficient patches to safely use
btrfs with subvolume snapshots and incremental send/receive? I ask
because 3.17.1 was released just before the btrfs patches for these
issues, so I have been waiting for 3.17.2. However, from reading the
kernel changelog, it appears that most of the included btrfs patches
were from July, August, and September, still too early for the btrfs
fixes I need. Thank you.

Tim
