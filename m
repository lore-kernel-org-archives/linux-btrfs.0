Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD5FC6379D
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Nov 2020 18:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F3D207BC
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Nov 2020 18:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404587AbgKZSC2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 26 Nov 2020 13:02:28 -0500
Received: from pio-pvt-msa2.bahnhof.se ([79.136.2.41]:44694 "EHLO
        pio-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391735AbgKZSC2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Nov 2020 13:02:28 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2020 13:02:27 EST
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTP id EEF873F4C7
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2020 18:55:53 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hmPoZRRrf21U for <linux-btrfs@vger.kernel.org>;
        Thu, 26 Nov 2020 18:55:53 +0100 (CET)
Received: by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 4D7213F47A
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2020 18:55:52 +0100 (CET)
Received: from [192.168.0.10] (port=55390)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93.0.4)
        (envelope-from <mail@lechevalier.se>)
        id 1kiLUt-0000Q8-Up
        for linux-btrfs@vger.kernel.org; Thu, 26 Nov 2020 18:55:59 +0100
Subject: Re: State of BTRFS
To:     linux-btrfs Mailinglist <linux-btrfs@vger.kernel.org>
References: <trinity-ca02807b-66c1-46e7-a4ed-efa79636413b-1606411979151@3c-app-gmx-bs37>
From:   A L <mail@lechevalier.se>
Message-ID: <6c2a1f42-962b-0671-2313-25e0b1fb0537@lechevalier.se>
Date:   Thu, 26 Nov 2020 18:55:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <trinity-ca02807b-66c1-46e7-a4ed-efa79636413b-1606411979151@3c-app-gmx-bs37>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2020-11-26 18:32, Steve Keller wrote:
> What is the state of btrfs concerning stability and reliability?
I think that the general opinion is that Btrfs profiles 
single,dup,RAID0,RAID1,RAID10,RAID1c34 are safe to use. RAID5/6 has 
issues and is not recommended unless you are experienced with Btrfs.

> Is it safe to my /home file system on btrfs?  I need no RAID,
> currently, as I have mdraid with LVM on top of that already, and I
> have an LVM volume for /home.  But I do like snapshots and would
> probably use them quite a lot.
In this configuration, Btrfs will be able to detect corruptions (bit 
files, faulty data, etc) but be able to repair it. Depending on your 
needs for LVM it may be better to run Btrfs RAID1 so you can utilize the 
full features of Btrfs that protects you from corrupt data.

You should read up on the risks with using volume managers underneath 
Btrfs. For example you can have issues if you use LVM snapshots.

>
> Currently, I have ext4 for /home but I consider switching to btrfs.
> But I want to be really sure not to loose data or otherwise have
> to repair the file system.
>
> Steve
>
Should not be less safe than copying your files over to the new Btrfs 
volume. I would not use btrfs-convert to convert the ext4 to Btrfs. 
Instead set up a new Btrfs volume and copy the files there.


