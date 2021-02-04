Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE3DC433DB
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Feb 2021 06:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDFFA64E35
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Feb 2021 06:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhBDG6p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 01:58:45 -0500
Received: from ste-pvt-msa2.bahnhof.se ([213.80.101.71]:13009 "EHLO
        ste-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhBDG6o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2021 01:58:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 818B3403D0;
        Thu,  4 Feb 2021 07:57:46 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (ste-ftg-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 65OzVvoaW4Lr; Thu,  4 Feb 2021 07:57:45 +0100 (CET)
Received: by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id C1EBE403C9;
        Thu,  4 Feb 2021 07:57:45 +0100 (CET)
Received: from [192.168.0.10] (port=62377)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93.0.4)
        (envelope-from <forza@tnonline.net>)
        id 1l7YaG-000Hi8-RF; Thu, 04 Feb 2021 07:57:44 +0100
Subject: Re: put 2 hard drives in mdadm raid 1 and detect bitrot like btrfs
 does, what's that called?
To:     Andrew Luke Nesbit <ullbeking@andrewnesbit.org>,
        Cedric.dewijs@eclipso.eu, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <f5d8af48e8d5543267089286c01c476f@mail.eclipso.de>
 <b143d6c2-4b13-ca6b-9e74-81d385da90f5@andrewnesbit.org>
From:   Forza <forza@tnonline.net>
Message-ID: <f71fbef6-6e22-c308-5275-93b518aaac49@tnonline.net>
Date:   Thu, 4 Feb 2021 07:57:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b143d6c2-4b13-ca6b-9e74-81d385da90f5@andrewnesbit.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2021-02-03 21:23, Andrew Luke Nesbit wrote:
> On 03/02/2021 19:04, Cedric.dewijs@eclipso.eu wrote:
>> I am looking for a way to make a raid 1 of two SSD's, and to be able 
>> to detect corrupted blocks, much like btrfs does that. I recall being 
>> told about a month ago to use a specific piece of software for that, 
>> but i forgot to make a note of it, and I can't find it anymore.
> 
> Running SSD's in RAID1 has been contentious from the perspective that I 
> have been researching storage technology.
> 
> Is there any serious, properly researched, and learned infornmation 
> available about this?
> 
> The reason I ask is that, in a related situation, I have 4x high quality 
> HGST SLC SAS SSD's, and I was seriously thinking that RAID0 might be the 
> appropriate way to configure them.  This assumes a well designed backup 
> strategy of course.
> 
> Is this foolhardy?
> 
> Andrew

Is there a reason why you are not considering Btrfs RAID1? It provides 
redundancy and checksums to protect against bit errors on either mirror. 
Remember that Btrfs RAID1 does not work the same way as mdadm's 
alternative.

RAID0 provides no fault tolerance at all. Is there any added performance 
you need from RAID0 in your application?

Forza
