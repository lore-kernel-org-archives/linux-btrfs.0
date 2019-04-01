Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EB0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 19:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8E4B2084B
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 19:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfDATWL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 15:22:11 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:20910 "EHLO
        smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfDATWL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 15:22:11 -0400
Received: from [94.217.144.7] (helo=[192.168.177.9])
        by smtprelay02.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hendrik@friedels.name>)
        id 1hB2VU-0000uE-7W
        for linux-btrfs@vger.kernel.org; Mon, 01 Apr 2019 21:22:08 +0200
From:   "Hendrik Friedel" <hendrik@friedels.name>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs and write barriers
Date:   Mon, 01 Apr 2019 19:22:08 +0000
Message-Id: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
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

Dear btrfs-team,

I am aware, that barriers are essential for btrfs [1].
I have some questions on that topic:
1) I am not aware how to determine, whether barriers are supported, 
except for searching dmesg for a message that barriers are disabled. Is 
that correct? It would be nice, if that could be determined before 
creating the FS.
2) I find the location of the (only?) warning -dmesg- well hidden. I 
think it would be better to notify the user when creating the 
file-system.
3) Even more, it would be good, if btrfs would disable the write cache 
in that case, so that one does not need to rely on the user
4) If [2] is still valid, there are drives 'lying' about their barrier 
support. Can someone comment? If that is the case, it would be even 
advisable to provide a test to test the actual capability. In fact, if 
this is still valid, this may be the reason for some btrfs corruptions 
that have been discussed here. [I did read, that LVM/Device-Mapper does 
not support barriers, but I think that this is outdated]

Greetings,
Hendrik


[1] 
https://btrfs.wiki.kernel.org/index.php/FAQ#I_see_a_warning_in_dmesg_about_barriers_being_disabled_when_mounting_my_filesystem._What_does_that_mean.3F
[2] https://brad.livejournal.com/2116715.html

