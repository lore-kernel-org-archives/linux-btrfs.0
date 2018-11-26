Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45657C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 19:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB83F20663
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 19:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nuclearwinter.com header.i=@nuclearwinter.com header.b="tpdK9ga3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB83F20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuclearwinter.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbeK0GIS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 01:08:18 -0500
Received: from titan.nuclearwinter.com ([205.185.120.7]:36616 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725723AbeK0GIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 01:08:18 -0500
X-Greylist: delayed 3311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2018 01:08:17 EST
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id wAQII9Lv003187
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 13:18:10 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com wAQII9Lv003187
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1543256290;
        bh=DRP9BWhAjR+kHxTTu0RgeOb/tcWWhG+TFtumZzxxZQ0=;
        h=To:From:Subject:Date:From;
        b=tpdK9ga3WuCiONIODfQVsA50NOC87kWP70FbYYxBYnPRw/Bhl//LIfnrpN7OiCV7+
         UrVJKLEUET7QIg+Z2PEns4AFyKueHUaRD7mIUdIPGKD/fa73Qp7CegRX+jMU4KeaZV
         KSTEJKRiZAlxFnV6WiqqKdo/iq/zdFp6a0ElnsZo=
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Possible deadlock when writing
Message-ID: <61991cd9-13ba-1834-3112-0f10e925a48c@nuclearwinter.com>
Date:   Mon, 26 Nov 2018 13:18:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.16 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Mon, 26 Nov 2018 13:18:10 -0500 (EST)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I started having a host freeze randomly when running a 4.18 kernel. The 
host was stable when running 4.17.12.

At first, it appeared that it was only IO that was frozen since I could 
run common commands that were likely cached in RAM and that did not 
touch storage. Anything that did touch storage would freeze and I would 
not be able to ctrl-c it.

I noticed today, when it happened with kernel 4.19.2, that backups were 
still running and that the backup app could still read from the backup 
snapshot subvol. It's possible that the backups are still able to 
proceed because the accesses are all read-only and the snapshot was 
mounted with noatime so the backup process never triggers a write.

There never are any errors output to the console when this happens and 
nothing is logged. When I first encountered this back in Sept. I managed 
to record a few sysrq dumps and attached them to a redhat ticket. See 
links below.

https://bugzilla.redhat.com/show_bug.cgi?id=1627288
https://bugzilla.redhat.com/attachment.cgi?id=1482177

I do have several VMs running that have their image files nocow'd. 
Interestingly, all the VMs, except 1, seem to be able to write just 
fine. The one that can't has frozen completely and is the one that 
regularly generates the most IO.

Any ideas on how to debug this further?

--Larkin
