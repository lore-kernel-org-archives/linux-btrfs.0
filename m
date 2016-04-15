Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:53563 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbcDOPm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 11:42:26 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors after rebooting with Magic Sysrq Keys
Date: Fri, 15 Apr 2016 17:42:21 +0200
MIME-Version: 1.0
Message-ID: <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
In-Reply-To: <5710B4B8.9020002@cn.fujitsu.com>
References: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
 <5710B4B8.9020002@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Is it 100% safe to run a btrfs check without --repair?
Because otherwise I will have to wait for my new external drive to arrive 
and make a backup first.

Thanks,
Niccolò

On venerdì 15 aprile 2016 11:30:32 CEST, Qu Wenruo wrote:
> Would you please run "btrfs check --readonly <your dm0>" and 
> paste the output?
>
> The dmesg seems very impossible:
>
>> BTRFS error (device dm-0): bad tree block start 245497856 245498111
>
> The later one is not even aligned to 2.
>
> But you system still seems mountable as you succeeded in 
> running btrfs scrub.
>
> So I assume either the tree block is not a critical one or the 
> copy saved you.
>
> Thanks,
> Qu
