Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36055 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077Ab3BTR2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 12:28:30 -0500
Received: by mail-ie0-f171.google.com with SMTP id 10so10184562ied.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 09:28:30 -0800 (PST)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Wed, 20 Feb 2013 18:28:10 +0100
Message-ID: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
Subject: basic questions regarding COW in Btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am trying to understand the COW mechanism in Btrfs. Is it correct to
say that unless nodatacow option is specified, Btrfs always performs
COW for all the data+metadata extents used in the system?

I saw that COWing is implemented in btrfs_cow_block() function, which
is called at the time of searching a slot for a particular item, while
inserting into a new slot, committing transactions, while creating
pending snapshots and few other places.

However, while tracing through the complete write path, I could not
quite figure out when extents actually get COWed. Could you please
point me to the place where COWing takes place? Is there any time
when, for performance or any other reasons, the extents are not COWed
but overwritten in place (apart from the explicit nodatacow flag being
set during mount)?

Thanks,
Aastha.
