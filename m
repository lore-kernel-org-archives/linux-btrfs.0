Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38433 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3HUDJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 23:09:53 -0400
Message-ID: <521430EF.5050409@oracle.com>
Date: Wed, 21 Aug 2013 11:15:59 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 3/3] btrfs-progs: avoid write to the disk before sure
 to create fs
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com> <1375877485-12105-1-git-send-email-anand.jain@oracle.com> <1375877485-12105-4-git-send-email-anand.jain@oracle.com> <20130820191941.GJ3990@localhost.localdomain>
In-Reply-To: <20130820191941.GJ3990@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/21/2013 03:19 AM, Josef Bacik wrote:
> On Wed, Aug 07, 2013 at 08:11:25PM +0800, Anand Jain wrote:
>> This patch provides fix for the following bug,
>>
>> When mkfs.btrfs fails the disks shouldn't be written.
>> ------------
>> btrfs fi show /dev/sdb
>> Label: none  uuid: 60fb76f4-3b4d-4632-a7da-6a44dea5573d
>>          Total devices 1 FS bytes used 24.00KiB
>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>>
>> mkfs.btrfs -dsingle -mraid1 /dev/sdb -f
>> ::
>> unable to create FS with metadata profile 16 (have 1 devices)
>>
>> btrfs fi show /dev/sdb
>> Label: none  uuid: 2da2179d-ecb1-4a4e-a44d-e7613a08c18d
>>          Total devices 1 FS bytes used 24.00KiB
>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>> -------------
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> This regresses making a filesystem that is forced to be a mixed block group.

  I guess you are talking about the regression which was addressed
  by the below patch:

     [PATCH] btrfs-progs: mkfs should check for small vol well before

  If this doesn't help, kindly provide the test case.
  I tried with the usual forced Mixed option it just works fine.
