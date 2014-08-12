Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:61462 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaHLJSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 05:18:10 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so13029159vcb.29
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 02:18:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 11:18:09 +0200
Message-ID: <CA+_UTVrV_Jt1cEsS4xi81XoVbsCw8MrcyeQLuZL-xgFDpGjzAA@mail.gmail.com>
Subject: Unlimited extended attributes
From: En Nu <b21enu@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Unlimited extended attributes
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Unlimited_extended_attributes
would be a very natural option to backup column-family-based databases
like Rocksdb to a filesystem, up to now only ZFS has support for
unlimited extended attributes.
Is there any progress concerning this feature?
Thanks,
Vincent
