Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:46410
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932582AbdBPPwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 10:52:49 -0500
Date: Thu, 16 Feb 2017 21:21:40 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: RAID5:Inject data stripe corruption and
 verify scrub fixes it.
Message-ID: <20170216155140.GA11026@giis.co.in>
References: <20170215090338.GA11666@giis.co.in>
 <e0a04535-80ad-671c-15b7-4a37305c1be4@cn.fujitsu.com>
 <20170215205622.GA2518@giis.co.in>
 <6fee8854-fc3f-c664-4004-b3579208b234@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6fee8854-fc3f-c664-4004-b3579208b234@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2017 at 09:12:31AM +0800, Qu Wenruo wrote:
> 
> 
> At 02/16/2017 04:56 AM, Lakshmipathi.G wrote:
> >On Wed, Feb 15, 2017 at 05:29:33PM +0800, Qu Wenruo wrote:
> >>
> >>
> >>At 02/15/2017 05:03 PM, Lakshmipathi.G wrote:
> >>>Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> >>>---
> >>>.../020-raid5-datastripe-corruption/test.sh        | 224 +++++++++++++++++++++
> >>>1 file changed, 224 insertions(+)
> >>>create mode 100755 tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >>>
> >>>diff --git a/tests/misc-tests/020-raid5-datastripe-corruption/test.sh b/tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >>>new file mode 100755
> >>>index 0000000..d04c430
> >>>--- /dev/null
> >>>+++ b/tests/misc-tests/020-raid5-datastripe-corruption/test.sh
> >>>@@ -0,0 +1,224 @@
> >>>+#!/bin/bash
> >>>+#
> >>>+# Raid5: Inject data stripe corruption and fix them using scrub.
> >>>+#
> >>>+# Script will perform the following:
> >>>+# 1) Create Raid5 using 3 loopback devices.
> >>>+# 2) Ensure file layout is created in a predictable manner.
> >>>+#    Each data stripe(64KB) should uniquely start with 'DNxxxx',
> >>>+#    where N represents the data stripe number.(ex:D0xxxx,D1xxxx etc)
> >>
> >>If you want really predictable layout, you could just upload compressed
> >>images for this purpose.
> >>
> >>Which makes things super easy, and unlike fstests, btrfs-progs self-test
> >>accepts such images.
> >>
> >>>+# 3) Once file is created with specific layout, gather data stripe details
> >>>+#    like devicename, position and actual on-disk data.
> >>>+# 4) Now use 'dd' to verify the data-stripe against its expected value
> >>>+#    and inject corruption by zero'ing out contents.
> >>>+# 5) After injecting corruption, running online-scrub is expected to fix
> >>>+#    the corrupted data stripe with the help of parity block and
> >>>+#    corresponding data stripe.
> >>
> >>You should also verify parity stripe is not corrupted.
> >>It's already known that RAID5/6 will corrupted parity while recovering data
> >>stripe.
> >>
> >>Kernel patch for this, with detailed bug info.
> >>https://patchwork.kernel.org/patch/9553581/
> >>
> >>>+# 6) Finally, validate the data stripe has original un-corrupted value.
> >>>+#
> >>>+#  Note: This script doesn't handle parity block corruption.
> >>
> >>Normally such test case should belong to xfstests (renamed to fstests
> >>recently) as we're verifying kernel behavior, not btrfs-progs behavior.
> >>
> >>But since fstests test case should be as generic as possible, and we don't
> >>have a good enough tool to corrupt given data/parity stripe, my previously
> >>submitted test case is rejected.
> >>
> >>Personally speaking, this seems to be a dilemma for me.
> >>
> >>We really need a test case for this, bugs has been spotted that RAID5/6
> >>scrub will corrupt P/Q while recovering data stripe.
> >>But we need to enhance btrfs-corrupt-block to a better shape to make fstests
> >>to accept it, and it won't take a short time.
> >>
> >>So I really have no idea what should we do for such test.
> >>
> >>Thanks,
> >>Qu
> >
> >Will check compressed images for parity strpe testing. I assume at the moment,
> >we currently support single static compressed image. Adding more than one static
> >compressed images like disk1.img disk2.img disk3.img for RAID is supported in
> >existing test framework?
> 
> Not yet, but since you can use test.sh instead of running check_image() from
> test frameset, it's never a big problem.
> 
ok, will check it out.
> >
> >Using compressed images for checking parity seems little easier than computing
> >via scripting.
> >
> >Looked into patch description:
> >
> >After scrubbing dev3 only:
> >0xcdcd (Good)  |      0xcdcd      | 0xcdcd (Bad)
> >    (D1)              (D2)            (P)
> >
> >So the Parity stripe (P) always get replaced by exact content of D1/D2 (data-stripe)
> >or by random  data?
> 
> Neither. it's just XOR result of D2(never changed, 0xcdcd) and old D1(wrong,
> 0x0000).
> 0xcdcd XOR 0x0000 = 0xcdcd
> 
> So you got 0xcdcd, bad result.
> 
> If you corrupt D1 with random data, then parity will be random then.
> 
> >If it always  get replaced by exact value from either
> >D1 or D2.  I think current script can be modified to detect that bug. If parity gets
> >replaced by random value, then it will the make task more difficult.
> 
> Not hard to detect.
> As the content is completely under your control, you know the correct parity
> value, and you can verify it very easy.
> 
The script corrupts data-stripe (D1 or D2) in the random manner. So lets assume wrong 
parity will be in random format.

I tried for one-liners in computing XOR of two strings. 
str1 = "D0xxxxx"
str2 = "D1xxxxx"

failed to figure it out. I think parity will be ""00010000000000000000000000000000"
for above case. For higher-numbered  data-stripe (D15xxxx), parity will be slighly 
different like "00001000000000000000000000000000"

parity value can be hard-coded as above instead of computing them based on data-stripe
inside the script. But finding location is another issue, at the moment
the script uses expensive/dumb approach like "cat /dev | hexdump | grep" to
find the location. If I use the same method, it may give more 1 parity location.

For example, D0xxxx/D1xxxx parity will be same as D2xxxx/D3xxxx parity.
With device rotation, it is possible same device will have multiple parity.
(in this case parity value will be same too).

I'm thinking solution like:
1) Find all possible parity value from a device
$cat /dev/loop2 | hexdump -e '"%010_ad  |" 16/1 "%02X" "\n" ' | grep "00010000000000000000000000000000"
0009502496  |00010000000000000000000000000000
0009633568  |00010000000000000000000000000000
0009649952  |00010000000000000000000000000000
0063176704  |00010000000000000000000000000000

Though few of them maynt be actual parity block. just count them as parity anyway (count=4)

2) After scrubbing, again check whether still count is 4, otherwise error out. There is huge chance parity 
value is wrong. (I tried manually - found parity 63176704 missing few times after scrub and 
offset has wrong data.)

> 
> So I'm working to improve btrfs-corrupt-block after finishing RAID5/6 bug
> fixes.
> 
> Thanks,
> Qu

ok,If possible, please include 'example usages' section in the man page of new btrfs-corrupt-block.
thanks.

Cheers.
Lakshmipathi.G

