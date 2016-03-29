Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:56951 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbcC2XSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 19:18:07 -0400
Received: by mail-vk0-f52.google.com with SMTP id k1so39486057vkb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 16:18:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160329194722.GC27148@jeknote.loshitsa1.net>
References: <20160318193937.GA21352@jek-Latitude-E7440>
	<56FA9420.8020503@oracle.com>
	<20160329194722.GC27148@jeknote.loshitsa1.net>
Date: Tue, 29 Mar 2016 16:18:02 -0700
Message-ID: <CAKWEGV7zmYAzzY_BJbPL7Cr8KVw2JDxO2qj7WKKAaJvCNuJ=7Q@mail.gmail.com>
Subject: Re: Global hotspare functionality
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reproduced with mason's for-linus-4.6 branch also.

2016-03-29 12:47 GMT-07:00 Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>:
> On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
>>
>> Hi Yauhen,
>>
>
>> >
>> >Issue 2.
>> >At start of autoreplacig drive by hotspare, kernel craches in transaction
>> >handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
>> >routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
>> >https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
>> >(oops text is attached also). Bdev is closed after replacing by
>> >btrfs_dev_replace_finishing(), so this is safe but doesn't seem
>> >to be right way.
>>
>>  I have sent out V2. I don't see that issue with this,
>>  could you pls try ?
>
> Yes, it reproduced on v4.4.5 kernel. I will try with current
> 'for-linus-4.6' Chris' tree soon.
>
> To emulate a drive failure, I disconnect the drive in VirtualBox, so bdev
> can be freed by kernel after releasing of all references to it.
