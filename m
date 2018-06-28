Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60459 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965541AbeF1Ph3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 11:37:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 43AE221B70
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 11:37:28 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8125810261
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 11:37:27 -0400 (EDT)
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
 <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <29e89355-2e35-8f2b-51ab-776f41fc2c70@georgianit.com>
Date: Thu, 28 Jun 2018 11:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------2C1DE2A9BDA678672310B303"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------2C1DE2A9BDA678672310B303
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-06-28 10:17 AM, Chris Murphy wrote:

> 2. The new data goes in a single chunk; even if the user does a manual
> balance (resync) their data isn't replicated. They must know to do a
> -dconvert balance to replicate the new data. Again this is a net worse
> behavior than mdadm out of the box, putting user data at risk.

I'm not sure this is the case.  Even though writes failed to the
disconnected device, btrfs seemed to keep on going as though it *were*.

When the array was re-mounted with both devices, (never mounted as
degraded), and scrub was run, scrub took a *long* time fixing errors, at
a whopping 3MB/s, and reported having fixed millions of them.



--------------2C1DE2A9BDA678672310B303
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


--------------2C1DE2A9BDA678672310B303--
