Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58566 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3KSFMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 00:12:05 -0500
Received: by mail-ie0-f169.google.com with SMTP id e14so3673352iej.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2013 21:12:04 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 18 Nov 2013 23:12:03 -0600
Message-ID: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
Subject: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
From: deadhorseconsulting <deadhorseconsulting@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In theory (going by the man page and available documentation, not 100%
clear) does the following command indeed actually work as advertised
and specify how metadata should be placed and kept only on the
"devices" specified after the "-m" flag?

Thus given the following example:
mkfs.btrfs -L foo -m raid10 <ssd> <ssd> <ssd> <ssd> -d raid10 <rust>
<rust> <rust> <rust>

Would btrfs stripe/mirror and only keep metadata on the 4 specified SSD devices?
Likewise then stripe/mirror and only keep data on the specified 4 spinning rust?

In trying and creating this type of setup it appears that data is also
being stored on the devices specified as "metadata devices". This is
observed through via a "btrfs filesystem show". after committing a
large amount of data to the filesystem The data devices have balanced
data as expected with plenty of free space but the SSD device are
reported as either nearly used or completely used.

- DHC
