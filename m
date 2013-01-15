Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20040 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3AOH6p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 02:58:45 -0500
Message-ID: <50F50DC1.8080201@oracle.com>
Date: Tue, 15 Jan 2013 16:05:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/11 V3] add show command to the subvol sub command
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com> <1357818083-15531-1-git-send-email-anand.jain@oracle.com> <50F383BF.3050204@oracle.com> <50F44DB6.4090802@gmail.com>
In-Reply-To: <50F44DB6.4090802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Goffredo,

  Thanks for the review.

 > I expected also from test1 and test2 something.

  actually it is working as intended. which is
  to show more info of any item under btrfs su list output,
  and root itself won't be in the btrfs su list (unless
  -a option is used), otherwise any suggestion what
  is good to have for btrfs su show / ?

Anand

On 01/15/2013 02:25 AM, Goffredo Baroncelli wrote:
> On 01/14/2013 05:04 AM, Anand Jain wrote:
>>
>>
>> Any comments on this new sub-command, please. ?
>>
>> Thanks, Anand
>>
> I am trying to use this new command. Very nice. However I tried to use
> it against the root of filesystem, without success:
>
> The root of filesystem is under /var/btrfs; I used a subvolume as root:
>
> $ cat /proc/self/mountinfo  | grep sdc3
> 19 1 0:15 /__active / rw,noatime,nodiratime - btrfs /dev/sdc3 rw,space_cache
> 25 19 0:15 / /var/btrfs rw,noatime,nodiratime - btrfs /dev/sdc3
> rw,space_cache
>
>
> If I do:
>
> $ #test 1
> $ sudo ./btrfs su show /
>
> I got nothing
>
> If I do
>
> $ #test 2
> $ sudo ./btrfs su show /var/btrfs/
>
> still, I got nothing
>
> $ #test 3
> $  sudo ./btrfs su show /var/btrfs/__active
>
> I, finally, got:
>
> /var/btrfs/__active
> 	uuid: 			835c96b8-c066-554b-9230-1c531e831ff6
> 	Parent uuid: 		-
> 	Creation time: 		-
> 	Object ID: 		256
> 	Generation (Gen): 	75774
> 	Gen at creation: 	0
> 	Parent: 		5
> 	Top Level: 		5
> 	Snapshot(s):
>
>
> I expected also from test1 and test2 something.
>
> BR
> G.Baroncelli
>
>
>
>
>
