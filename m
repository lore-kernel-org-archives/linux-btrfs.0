Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35775 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbcCCPdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 10:33:32 -0500
Received: by mail-io0-f182.google.com with SMTP id g203so30994894iof.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 07:33:31 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Mar 2016 15:33:31 +0000
Message-ID: <CAO5K3OcqZTTRr=p==Awd0VVQ507M-CP6dQqgwtrXUYqpUBUu+g@mail.gmail.com>
Subject: btrfs-progs: btrfs convert v2
From: Vytautas D <vytdau@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu, thanks for your work on btrfs convert.

Does your btrfs convert work ( namely
https://www.spinics.net/lists/linux-btrfs/msg49719.html patches )
change any caveats described here ->
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3#Before_first_use

i.e. does larger than 1 gb files still needs defrag after which
rollback is not possible ?

Thanks,
Vytas
