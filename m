Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40643 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbeIUEHe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 00:07:34 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id A766D21841
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 18:21:52 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 327B5102D2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 18:21:52 -0400 (EDT)
Subject: Re: btrfs problems
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
 <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
 <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
 <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
 <CAMrg+aQV97Cv4WgH-DQvwDikFydrxD-zeJajUk3iLk1oKf12_A@mail.gmail.com>
 <CAJCQCtQ6GQ=oihewodXDOfSRE1X_gE=esxY7kZnPZmCXYHGqiA@mail.gmail.com>
 <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <0e1d41bc-7ac4-47cf-4b16-6b3732c90f2e@georgianit.com>
Date: Thu, 20 Sep 2018 18:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------35B256E5F8B868B51F700C35"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------35B256E5F8B868B51F700C35
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-09-20 05:35 PM, Adrian Bastholm wrote:
> Thanks a lot for the detailed explanation.
> Aabout "stable hardware/no lying hardware". I'm not running any raid
> hardware, was planning on just software raid. three drives glued
> together with "mkfs.btrfs -d raid5 /dev/sdb /dev/sdc /dev/sdd". Would
> this be a safer bet, or would You recommend running the sausage method
> instead, with "-d single" for safety ? I'm guessing that if one of the
> drives dies the data is completely lost
> Another variant I was considering is running a raid1 mirror on two of
> the drives and maybe a subvolume on the third, for less important
> stuff

In case you were not aware, it's perfectly acceptable with BTRFS to use
Raid 1 over 3 devices.  Even more amazing, regardless of how many
devices you start with, 2, 3, 4, whatever, you can add a single drive to
the array to increase capacity,  (at 50%, of course,, ie, adding a 4TB
drive will give you 2TB usable space, assuming the other drives add up
to at least 4TB to match it.)



--------------35B256E5F8B868B51F700C35
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------35B256E5F8B868B51F700C35--
