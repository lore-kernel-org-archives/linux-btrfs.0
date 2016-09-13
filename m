Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:45550 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbcIMLea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 07:34:30 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Commit 'synchronize incompat feature bits with sysfs files' still
 missing in for-next?
Message-ID: <57D7E442.2010400@applied-asynchrony.com>
Date: Tue, 13 Sep 2016 13:34:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I've noticed that the 4.5-rc commit 14e46e04:
'btrfs: synchronize incompat feature bits with sysfs files' [1]
was reverted later in [2], but despite fixes to protect sysfs
with locks & exorcise GFP_NOFS in favor of GFP_KERNEL it was
never reinstated - neither for 4.5-final, nor later..and it's
been quite a while since then. Is this still valid?

I ask because I've just noticed I've had this in my tree since
forever, but have never encountered a problem during balance -
probably because of all the other fixes.

thanks,
Holger

[1] goo.gl/2DBMSe
[2] goo.gl/cIKgv5
