Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaLaGEP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 01:04:15 -0500
Message-ID: <54A391D8.6020201@redhat.com>
Date: Wed, 31 Dec 2014 00:04:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, Dave Stevens <geek@uniserve.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: should I use btrfs on Centos 7 for a new production server?
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com> <B12D4A1D-8EB5-4C9B-A8DC-7280D333E2BC@gmail.com> <D5E9E585-E843-4D79-A881-EB5863FB4F8B@gmail.com>
In-Reply-To: <D5E9E585-E843-4D79-A881-EB5863FB4F8B@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/30/14 10:06 PM, Wang Shilong wrote:
> 
>>
>> Hello,
>>
>>>
>>> I have a well tested and working fine Centos5-Xen system. Accumulated cruft from various development efforts make it desirable to redo the install. Currently a RAID-10 ext4 filesystem with LVM and 750G of storage. There's a hot spare 750 drive in the system.
>>>
>>> I'm thinking of migrating the web sites (almost the only use of the server) to a spare then installing Centos-7 and btrfs, then migrating the sites back.
>>>
>>> I see RH marks btrfs in C7 as a technology preview but don't understand what that implies for future support and a suitably stable basis for storage.
>>>
>>> The demand on the system is low and not likely to change in the near future, storage access speeds are not likely to be dealbreakers and it would be nice to not need to use LVM, btrfs seems to have a better feature set and more intuitive command set. But I'm uncertain about stability. Anyone have an opinion?
>>>
>>
>> I used CentOS7 btrfs myself, just doing some tests..it crashed easily.
>> I don’t know how much efforts that Redhat do on btrfs for 7 series.
> 
> Maybe use SUSE enterprise for btrfs will be a better choice, they offered
> better support for btrfs as far as i know.

I believe SuSE's most recent support statement on btrfs is here, I think.

https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221

-Eric
