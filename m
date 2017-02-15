Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:45540
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdBOU6x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:58:53 -0500
Date: Thu, 16 Feb 2017 02:26:22 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: RAID5:Inject data stripe corruption and
 verify scrub fixes it.
Message-ID: <20170215205622.GA2518@giis.co.in>
References: <20170215090338.GA11666@giis.co.in>
 <e0a04535-80ad-671c-15b7-4a37305c1be4@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e0a04535-80ad-671c-15b7-4a37305c1be4@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 05:29:33PM +0800, Qu Wenruo wrote:
> 
> 
> At 02/15/2017 05:03 PM, Lakshmipathi.G wrote:
> >Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> >---
> > .../020-raid5-datastripe-corruption/test.sh        | 224 +++++++++++++++++++++
> > 1 file changed, 224 insertions(+)
> > create mode 100755 tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >
> >diff --git a/tests/misc-tests/020-raid5-datastripe-corruption/test.sh b/tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >new file mode 100755
> >index 0000000..d04c430
> >--- /dev/null
> >+++ b/tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >@@ -0,0 +1,224 @@
> >+#!/bin/bash
> >+#
> >+# Raid5: Inject data stripe corruption and fix them using scrub.
> >+#
> >+# Script will perform the following:
> >+# 1) Create Raid5 using 3 loopback devices.
> >+# 2) Ensure file layout is created in a predictable manner.
> >+#    Each data stripe(64KB) should uniquely start with 'DNxxxx',
> >+#    where N represents the data stripe number.(ex:D0xxxx,D1xxxx etc)
> 
> If you want really predictable layout, you could just upload compressed
> images for this purpose.
> 
> Which makes things super easy, and unlike fstests, btrfs-progs self-test
> accepts such images.
> 
> >+# 3) Once file is created with specific layout, gather data stripe details
> >+#    like devicename, position and actual on-disk data.
> >+# 4) Now use 'dd' to verify the data-stripe against its expected value
> >+#    and inject corruption by zero'ing out contents.
> >+# 5) After injecting corruption, running online-scrub is expected to fix
> >+#    the corrupted data stripe with the help of parity block and
> >+#    corresponding data stripe.
> 
> You should also verify parity stripe is not corrupted.
> It's already known that RAID5/6 will corrupted parity while recovering data
> stripe.
> 
> Kernel patch for this, with detailed bug info.
> https://patchwork.kernel.org/patch/9553581/
> 
> >+# 6) Finally, validate the data stripe has original un-corrupted value.
> >+#
> >+#  Note: This script doesn't handle parity block corruption.
> 
> Normally such test case should belong to xfstests (renamed to fstests
> recently) as we're verifying kernel behavior, not btrfs-progs behavior.
> 
> But since fstests test case should be as generic as possible, and we don't
> have a good enough tool to corrupt given data/parity stripe, my previously
> submitted test case is rejected.
> 
> Personally speaking, this seems to be a dilemma for me.
> 
> We really need a test case for this, bugs has been spotted that RAID5/6
> scrub will corrupt P/Q while recovering data stripe.
> But we need to enhance btrfs-corrupt-block to a better shape to make fstests
> to accept it, and it won't take a short time.
> 
> So I really have no idea what should we do for such test.
> 
> Thanks,
> Qu

Will check compressed images for parity strpe testing. I assume at the moment,
we currently support single static compressed image. Adding more than one static
compressed images like disk1.img disk2.img disk3.img for RAID is supported in
existing test framework?

Using compressed images for checking parity seems little easier than computing
via scripting.

Looked into patch description:

After scrubbing dev3 only:
0xcdcd (Good)  |      0xcdcd      | 0xcdcd (Bad) 
    (D1)              (D2)            (P) 

So the Parity stripe (P) always get replaced by exact content of D1/D2 (data-stripe)
or by random  data? If it always  get replaced by exact value from either
D1 or D2.  I think current script can be modified to detect that bug. If parity gets
replaced by random value, then it will the make task more difficult.

Yes, without better support for RAID with tools like btrfs-corrupt-block, it will be
hard to play-around with RAID to create test scripts.

Cheers.
Lakshmipathi.G
