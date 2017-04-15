Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:53112
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdDOJKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 05:10:32 -0400
Date: Sat, 15 Apr 2017 14:39:21 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: fsck-tests: verify 'btrfs check
 --repair' fixes corrupted nlink field
Message-ID: <20170415090921.GA5677@giis.co.in>
References: <20170202080502.GA6676@giis.co.in>
 <20170330155211.GK4781@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170330155211.GK4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 30, 2017 at 05:52:11PM +0200, David Sterba wrote:
> On Thu, Feb 02, 2017 at 01:35:02PM +0530, Lakshmipathi.G wrote:
> > Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> > ---
> >  tests/fsck-tests/026-check-inode-link/test.sh | 30 +++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >  create mode 100755 tests/fsck-tests/026-check-inode-link/test.sh
> > 
> > diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
> > new file mode 100755
> > index 0000000..6822ee2
> > --- /dev/null
> > +++ b/tests/fsck-tests/026-check-inode-link/test.sh
> > @@ -0,0 +1,30 @@
> > +#!/bin/bash
> > +# verify that 'btrfs check --repair' fixes corrupted inode nlink field
> > +
> > +source $TOP/tests/common
> > +
> > +check_prereq btrfs-corrupt-block
> > +check_prereq mkfs.btrfs
> > +
> > +setup_root_helper
> > +prepare_test_dev 512M
> 
> Please use default size unless you really need 512M for the test
> purposes.
> 
> > +
> > +test_inode_nlink_field()
> > +{
> > +	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
> > +
> > +	run_check_mount_test_dev
> > +	run_check $SUDO_HELPER touch $TEST_MNT/test_nlink.txt
> > +
> > +	# find inode_number
> > +	inode_number=`stat -c%i $TEST_MNT/test_nlink.txt`
> > +	run_check_umount_test_dev
> > +
> > +	# corrupt nlink field of inode object
> > +        run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -i $inode_number \
> > +		-f nlink $TEST_DEV
> > +
> > +	check_image $TEST_DEV
> 
> The wrapper runs a pre-check that must detect errors, then runs --repair
> and then again a plain check. Is this intended here?
> 
Yes its intentional. The test should fail, if its unable to detect the corruption.
This is to ensure btrfs-corrupt-block -f nlink works as expected.
> I think we should try to mount the fixed image again and read the file
> or check link count.
> 
Right, I missed the verification part, will added this and change prepare_test_dev 
to default size.
> Please add shell quotation around all variables.
Now quotation is added.

Cheers.
Lakshmipathi.G
