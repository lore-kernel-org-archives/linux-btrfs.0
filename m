Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35400 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbcHFUqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 16:46:34 -0400
Received: by mail-wm0-f47.google.com with SMTP id f65so68218583wmi.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 13:46:34 -0700 (PDT)
MIME-Version: 1.0
From: Karl Herler <karl.herler@gmail.com>
Date: Sat, 6 Aug 2016 09:58:57 +0300
Message-ID: <CAK7rSWKrquTN3TbJgcri21VAfuR_wE4nC-TRDn_eGeF+8VJdRQ@mail.gmail.com>
Subject: Save way to migrate from raid 5/6?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

What is the safest way to migrate an existing raid 5/6 setup, to say raid 10?

Will simply running `btrfs filesystem balance start -dconvert=10
-mconvert=10` work or is it sensitive to the parity calculation issue?

Can I `btrfs device delete` some of the drives, format them and copy
over the data from the raid 5/6, or will delete risk running into the
issue?


Best regards,
Karl Herler
