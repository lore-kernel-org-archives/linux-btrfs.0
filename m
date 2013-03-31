Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:62017 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3CaKyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 06:54:06 -0400
Received: by mail-da0-f43.google.com with SMTP id u36so725266dak.30
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 03:54:04 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [BUG] btrfs quota
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <515800BB.50102@gmx.net>
Date: Sun, 31 Mar 2013 18:54:00 +0800
Cc: "list.btrfs@jan-o-sch.net Schmidt" <list.btrfs@jan-o-sch.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <F31FCD5E-ADD7-4725-9D87-C2713306DBED@gmail.com>
References: <1DF9A68C-FBA2-460F-921F-CBF94A06CD6B@gmail.com> <515800BB.50102@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Arne,

However, I remember that i have hit this panic in several kernel version.
And i will double check it tomorrow when i am in the work..

If possible, i will send you the message from dmesg.

Thanks,
Wang

> Hello Wang,
> 
> On 03/31/13 03:44, Wang Shilong wrote:
>> Hello Arne, Jan,
>> 
>> When i run stresstest with quota enabled, i hit a panic where
>> btrfs_find_all_roots() is called. Would you please double check it.
>> 
> 
> On what kernel version do you hit this (git commit id preferred)?
> Can you send us the message from dmesg?
> 
> Thanks,
> arne
> 
>> stresstest -n 10000  -t 4.
>> 
>> Maybe there is still race condition when walking backref  trees, Jan
>> would you please check the backref.c ..
>> btrfs_find_all_roots() is called in btrfs_qgroup_account_ref () to find
>> all roots that reference a extent. I think this is called because
>> 
>> we introduce referenced/exclusive concepts. The point is that i think
>> this concept's disadvantages outweigh the advantages:
>>      <1>
>> walking backref  tree is really time-consuming.
>> <2> referenced/exclusive makes it really complex when snapshot happens.
>> <3> quota has a high coupling with other module.
>>     I'd prefer to just keep referenced value, it is not be elegant, but
>> it helps more.
>> 
>> Thanks,
>> Wang
>> 
>> 
>> 
>> 
>> 
> 

