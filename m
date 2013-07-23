Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53510 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3GWOck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 10:32:40 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so8572401pbb.28
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 07:32:40 -0700 (PDT)
Received: from localhost (c-50-152-158-98.hsd1.ca.comcast.net. [50.152.158.98])
        by mx.google.com with ESMTPSA id qh10sm2231358pbb.33.2013.07.23.07.32.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 07:32:38 -0700 (PDT)
Date: Tue, 23 Jul 2013 07:32:36 -0700
From: Curtis Shimamoto <sugar.and.scruffy@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Different size devices in RAID
Message-ID: <20130723143236.GA12119@thinkpad.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs people,

I am using btrfs to span across two SSDs at the moment.  One is a 256GB
and the other is a 128GB.  So as of now, I have the data in "single" form
and the metadata in a RAID1. I have heard that btrfs can adjust to some
degree for devices in a RAID array that vary in sizes due to the way it
handles things.  But I feel as though the size difference between those
two would be too vast to compensate for whatsoever.

But I have an additional SSD in my machine, which is also a 128GB drive.
I know that with RAID1, it will only duplicate the data no matter how
many devices are present in the array.  So if that is the case, if I were
to add all three of my SSDs into the filesystem, and then put the data
into a RAID1, would it be able to make use of all the space?  The two
smaller ones are about equal to the size of the larger, so in my mind it
would seem that it would be entirely possible for it to keep two copies
of each extent while still utilizing all the space.  But I don't know if
btrfs is set up to recognize this situation or how it would handle it.

I know that I could potentially put the two smaller drives in some kind
of an LVM or mdadm, but I would like to avoid this if possible.  It just
seems like an unnecessary layer of complexity.

Though my question is about RAID1 specifically, as I would like to use
the potential of the self healing features, I guess it would also extend
to RAID0 as well.  Would that be able to make efficient use of the space?

Additionally, though not quite as much of a concern to me, the machine in
which these drives live is an Ivy Bridge Laptop, so there are actually
only two available SATA3 ports.  The odd drive out at this point in time
is actually an mSATA which is the only SATA2 port.  If I were to add this
to an array (assuming the above questions have favorable answers), how
dramatically would the speed of the array be affected?  To be honest, the
speed of even just the mSATA drive alone is enough to keep me happy.  But
I have just been very curious about this.  The write speeds of all three
are relatively close. But the read speeds on the SATA3 are significantly
faster than the mSATA.

Anyway, thanks for the fantastic filesystem.  Sorry for the long email,
but these questions have been in the back of my mind for some time now.
For the first question(s) at least I have not been able to find anything
regarding that scenario.

Regards,
-- 
Curtis Shimamoto
sugar.and.scruffy [at] gmail.com
