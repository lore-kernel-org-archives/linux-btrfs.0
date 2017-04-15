Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:40906
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752091AbdDOKQP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 06:16:15 -0400
Date: Sat, 15 Apr 2017 15:45:04 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: misc-tests: Superblock corruption and
 recovery using backup.
Message-ID: <20170415101504.GA7640@giis.co.in>
References: <20170216223159.GA23242@giis.co.in>
 <20170313171504.GN14605@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313171504.GN14605@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 06:15:04PM +0100, David Sterba wrote:
> On Fri, Feb 17, 2017 at 04:01:59AM +0530, Lakshmipathi.G wrote:
> > Test script to recover damaged primary superblock using backup superblock.
> > 
> > Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> 
> Thanks for the test, a few comments below.
> 
> > ---
> >  .../019-fix-superblock-corruption/test.sh          | 36 ++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >  create mode 100755 tests/misc-tests/019-fix-superblock-corruption/test.sh
> > 
> > diff --git a/tests/misc-tests/019-fix-superblock-corruption/test.sh b/tests/misc-tests/019-fix-superblock-corruption/test.sh
> > new file mode 100755
> > index 0000000..95815e4
> > --- /dev/null
> > +++ b/tests/misc-tests/019-fix-superblock-corruption/test.sh
> > @@ -0,0 +1,36 @@
> > +#!/bin/bash
> > +#
> > +# Corrupt primary superblock and restore it using backup superblock.
> > +#
> > +
> > +source $TOP/tests/common
> > +
> > +check_prereq btrfs-select-super
> > +check_prereq btrfs
> > +
> > +setup_root_helper
> > +prepare_test_dev 512M
> > +
> > +FIRST_SUPERBLOCK_OFFSET=65536
> > +
> > +test_superblock_restore()
> > +{
> > +	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
> > +
> > +	# Corrupt superblock checksum
> > +        dd if=/dev/zero of=$TEST_DEV seek=$FIRST_SUPERBLOCK_OFFSET bs=1 \
> > +        count=4  conv=notrunc &> /dev/null
> > +	# Run btrfs check to detect corruption
> > +	$TOP/btrfs check $TEST_DEV >& /dev/null && \
> > +		_fail "btrfs check should detect corruption"
> 
> No run_check? In general all test output is desired and should be in the
> test log so you can use 'run_mayfail'. Also, please keep the entier
> output and don't redirect it to /dev/null .
> 
> > +	# Copy backup superblock to primary
> > +	run_check $TOP/btrfs-select-super -s 1 $TEST_DEV
> > +
> > +	echo "Performing btrfs check" &>> $RESULTS
> 
> Use _log for that
> 
> > +	$TOP/btrfs check $TEST_DEV &>> $RESULTS
> 
> Use run_check
> 
> > +        if [ $? -ne 0 ]; then
> > +		_fail "Failed to fix superblock."
> 
> And this would be unnecessary.
> 
> I've added a section to tests/README.md to describe the common coding
> practices. Feel free to read/update/fix. Older tests could violate the
> recommendations so at least new tests are in line and we'll update the
> rest incrementally.

Just sent a new patch(v4), addressing above review comments.thanks.

Cheers.
Lakshmipathi.G


