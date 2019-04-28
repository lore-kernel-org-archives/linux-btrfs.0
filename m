Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FED7C43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 20:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD456206A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 20:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="qENFNVqZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfD1UqS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 16:46:18 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:37218 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfD1UqS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 16:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Reply-To; bh=bY40Rs9m5Z+6NubZl+sJuJxT7pTqz1xGsORYeeLQnxk=;
        b=qENFNVqZby4edtrYDdQFxdnDKrpFFqY+4hjqduJsJ5QXU/ssn45kEQ3VcUC8eW5ukqzPqNFx6evDompWNpstdMC4p6LP0a9D59PafVrdbTOXZqtlZekgHLGdfjv4nC27iQTd2tJKy6y4xpYg2bdcRI/6uuMQJVNMf7evIoJh1xRawsViLwY9IXJ7n8YtpmsSXOJdEQkfp4dG33glJRDigBFTg4S7ko6TJRoSw+1OCNkoWoPFL7gKApz+TzxOU8BlansIZo1WWTNlDUhuwl6BE18o1Vh2wSOi1ynJ31CTynhLbOXuMtiScNTQ2jXMRo1sjpPK9f1VYry18saBqkeQ6A==;
Received: from 73.79-160-166.customer.lyse.net ([79.160.166.73]:32678 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1hKqgi-0000E3-19; Sun, 28 Apr 2019 22:46:16 +0200
Reply-To: waxhead@dirtcellar.net
Subject: Re: Migration to BTRFS
To:     Hendrik Friedel <hendrik@friedels.name>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <1f19cf95-10aa-ddad-8ca7-ad483a7003f4@dirtcellar.net>
Date:   Sun, 28 Apr 2019 22:46:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hendrik Friedel wrote:
> Hello,
> 
> I intend to move to BTRFS and of course I have some data already.
> I currently have several single 4TB drives and I would like to move the 
> Data onto new drives (2*8TB). I need no raid, as I prefer a backup. 
> Nevertheless, having raid nice for availability. So why not in the end. 
> I currently use ~6TB, so it may work, but I would be able to remove the 
> redundancy later.
> 
> So, if I understand correctly, today I want
> -m raid1 -d raid1
> 
> whereas later, I want
> -m raid1 -d single
> 
> What is very important to me is, that with one failing drive, I have no 
> risk of losing the whole filesystem, but only losing the affected drive. 
> Is that possible with both of these variants?
> 
> Is it possible to move between the two (doing a balance, of course?
> Any other thoughts/recommendations?
> 
If I where you, with your use case I would consider using mhddfs 
https://romanrm.net/mhddfs which is filesystem agnostic layer on top of 
2x [-m DUP, -d SINGLE] BTRFS drives. Last time I tested mhddfs (about 5+ 
years ago) it was dead slow, but that might not be very important to 
you. For what it does it works great!

If you label your device DISK_A and DISK_B and then your backups 
BACKUP_A and BACKUP_B you just have to copy back the A or B set if one 
disk fails.

And before Duncan jumps in , remember that backup is not a backup unless 
it has a extra backup ... But seriously (really, seriously!!), read any 
of Duncan's posts. He does a stellar job of explaining why you need to 
have have tested, working backups of data you care about!


> Greetings,
> Hendrik
> 
> 
