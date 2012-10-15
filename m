Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:57784 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2JOTVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 15:21:22 -0400
Message-ID: <507C6239.1030208@profihost.ag>
Date: Mon, 15 Oct 2012 21:21:29 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: problems with btrfs send / restore
References: <50771F22.3070501@profihost.ag> <20121011194335.GE4405@twin.jikos.cz> <50772408.9040303@profihost.ag> <507BE264.1060500@cn.fujitsu.com>
In-Reply-To: <507BE264.1060500@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 15.10.2012 12:16, schrieb Miao Xie:
> On 	thu, 11 Oct 2012 21:54:48 +0200, Stefan Priebe wrote:
>> Am 11.10.2012 21:43, schrieb David Sterba:
>>> On Thu, Oct 11, 2012 at 09:33:54PM +0200, Stefan Priebe wrote:
>>>> [server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1
>>>> /btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
>>>> At subvol /btrfs/src/@snapshot/2
>>>> At subvol 2
>>>> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No such file or directory
>>>                                         ^^^^^^^^^^^^^^^^^^^
>>>
>>> I wonder if this is the ghost snapshot dir entry that Miao fixed. Did
>>> somehow get into the 'send' stream and confused the receive side.
>>>
>>> david
>>
>> i missed two facts:
>> 1.) vanilla kernel 3.6.1
>> 2.) latest btrfs tools git (cloned at 10/10/2012)
>
> Sorry, I can not reproduce this problem, could you send me the detailed steps?

mhm there is nothing special. But i try to provide more information / a 
small howto:

# mount |grep btrfs
/dev/sdb on /btrfs/src type btrfs (rw)
/dev/sdc on /btrfs/target type btrfs (rw)

# btrfs subvolume list /btrfs/target/
# btrfs subvolume list /btrfs/src/
ID 277 top level 5 path @snapshot/1
ID 278 top level 5 path @snapshot/2
ID 288 top level 5 path @snapshot/3

# btrfs send /btrfs/src/\@snapshot/1 | btrfs receive 
/btrfs/target/\@snapshot/
At subvol /btrfs/src/@snapshot/1
At subvol 1
#

Now i was trying to send an incremental snapshot:
# btrfs send -i /btrfs/src/\@snapshot/1 /btrfs/src/\@snapshot/2 | btrfs 
receive /btrfs/target/\@snapshot/
At subvol /btrfs/src/@snapshot/2
At subvol 2
ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No 
such file or directory
#

Greets,
Stefan
