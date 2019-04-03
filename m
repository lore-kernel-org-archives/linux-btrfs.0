Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A83C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 20:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3856A20882
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 20:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfDCUHH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 16:07:07 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:50090 "EHLO
        smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbfDCUHG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 16:07:06 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 16:07:05 EDT
Received: from [94.217.144.7] (helo=[192.168.177.20])
        by smtprelay02.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hendrik@friedels.name>)
        id 1hBliG-0007LG-0D
        for linux-btrfs@vger.kernel.org; Wed, 03 Apr 2019 21:38:20 +0200
From:   "Hendrik Friedel" <hendrik@friedels.name>
To:     linux-btrfs@vger.kernel.org
Subject: Re[3]: btrfs and write barriers
Date:   Wed, 03 Apr 2019 19:38:09 +0000
Message-Id: <em3661e885-dc21-4837-8f2a-1ce91371edff@ryzen>
In-Reply-To: <eme2e3d545-ea78-4120-9800-6a33db6c506b@ryzen>
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
 <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
 <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
 <eme2e3d545-ea78-4120-9800-6a33db6c506b@ryzen>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
User-Agent: eM_Client/7.2.34062.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Df-Sender: aGVuZHJpa0BmcmllZGVscy5uYW1l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,
thanks for your reply.

 >>3) Even more, it would be good, if btrfs would disable the write cache
 >> in that case, so that one does not need to rely on the user
 >
 >Personally speaking, if user really believes it's write cache causing
 >the problem or want to be extra safe, then they should disable cache.
How many percent of the users will be able to judge that?

 >As long as FLUSH is implemented without problem, the only faulty part 
is
 >btrfs itself and I haven't found any proof of either yet.
But you have searched?

 >>2) I find the location of the (only?) warning -dmesg- well hidden. I 
think it would be better to notify the user when creating the 
file-system.
 >A notification on creating the volume and ones when adding devices 
(either via `device add` or via a replace operation)
 >would indeed be nice, but we should still keep the kernel log warning.

Ok, so what would be the way to move forward on that? Would it help if I 
create an issue in a https://bugzilla.kernel.org/ ?

 >>3) Even more, it would be good, if btrfs would disable the write cache 
in that case, so that one does not need to rely on the user
 > I would tend to disagree here. We should definitely _recommend_ this 
to the user if we know there is no barrier support, but just
 > doing it behind their back is not a good idea.

Well, there is some room between 'automatic' and 'behind their back. 
E.g.
"Barriers are not supported by /dev/sda. Automatically disabling 
write-cache on mount. You can suppress this with the 
'enable-cache-despite-no-barrier-support-I-know-what-I-am-doing' mount 
option (maybe, we can shorten the option).

 > There are also plenty of valid reasons to want to use the write cache 
anyway.

I cannot think of one. Who would sacrifice data integrity/potential 
total loss of the filesystem for speed?

 > As far as FUA/DPO, I know of exactly _zero_ devices that lie about 
implementing it and don't.
...
 > but the fact that Linux used to not issue a FLUSH command to the disks 
when you called fsync in userspace.

Ok, thanks for that clarification.


Greetings,
Hendrik

