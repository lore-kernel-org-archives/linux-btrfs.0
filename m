Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63933 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3NsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:48:03 -0500
Received: by mail-qc0-f174.google.com with SMTP id c9so6487116qcz.5
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 05:48:02 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 19:17:42 +0530
Message-ID: <CAH-HCWVmRUqSTX5_rMjDOxCysGfeZ47hyTN_ObRKomyxSTwK9Q@mail.gmail.com>
Subject: Considerations in snapshotting and send/receive of nocow files?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given that snapshotting effectively reduces the usefulness of nocow, I
suppose the preferable model to snapshotting and send/receiving such
files would be different than other files.

Should nocow files (for me only VBox images) preferably be:

1) under a separate subvolume?

2) said subvol snapshotted less often?

3) sent/received any differently?

Thanks.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
