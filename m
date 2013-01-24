Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58972 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3AXPMO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 10:12:14 -0500
Received: by mail-vc0-f172.google.com with SMTP id l6so7606749vcl.31
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 07:12:13 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Jan 2013 16:12:13 +0100
Message-ID: <CAEgy6-3jQ3nkFqY-eJj86vDSsfZQ2naiA-VoMw-U-TPaBd3Pew@mail.gmail.com>
Subject: Quota reached: can't delete
From: Jerome M <jmwdev38@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

With the current btrfs quota implementation, when you reach a
subvolume quota limit, you can't delete anything without first
removing the limit or enlarge it:

rm: cannot remove `testfile.bin': Disk quota exceeded


Is there any plan to change that?

Thanks,
Jerome
