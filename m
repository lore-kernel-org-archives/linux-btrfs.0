Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:45496
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdBBERS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Feb 2017 23:17:18 -0500
Date: Thu, 2 Feb 2017 09:46:06 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck-tests: verify 'btrfs check --repair'
 fixes corrupted nlink field
Message-ID: <20170202041606.GA3167@giis.co.in>
References: <20170128104726.GA4757@giis.co.in>
 <dd4709b8-3d1d-6285-d5e5-c4f6962856e3@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dd4709b8-3d1d-6285-d5e5-c4f6962856e3@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> apply anymore, but I'm expecting some more changes to it so please adapt
> it to the new file

Not sure what went wrong, will test the next patch with git apply and send it.

> 
> I prefer 'inode_number' or simple 'ino' for the variable name.
> 

Okay, will use inode_number.

> >+
> >+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV &>> $RESULTS && \
> >+			_fail "btrfs check failed to detect nlink corruption"
> >+	run_check $SUDO_HELPER $TOP/btrfs check --repair $TEST_DEV
> >+	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
> 
> What about using check_image() here?

I didn't know about check_image(), looks like above 3 lines can be replaced
with check_image. Will make the change.

> 
> Thanks,
> Qu
> 

Cheers.
Lakshmipathi.G
