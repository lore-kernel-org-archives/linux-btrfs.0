Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:33943 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030448AbaGRRzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 13:55:42 -0400
Received: from [172.17.0.4] (unknown [76.14.35.15])
	by smtp.webfaction.com (Postfix) with ESMTP id 6386066EC3D2
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 17:31:20 +0000 (UTC)
Message-ID: <53C959FE.7070808@glidelink.net>
Date: Fri, 18 Jul 2014 10:31:42 -0700
From: Daniel Mizyrycki <mzdaniel@glidelink.net>
Reply-To: mzdaniel@glidelink.net
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
References: <1405627978.2630.39.camel@s-Air> <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com> <1405688218.3085.16.camel@s-Air> <1483007.OXNgJN24dh@xev>
In-Reply-To: <1483007.OXNgJN24dh@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 07/18/14 06:40, Russell Coker wrote:
>>> Displaying backups is an issue of backup software. It is above the
>>> level that BTRFS development touches. While people here can probably
>>> offer generic advice on backup software it's not the topic of the
>>> list.
>>
>> As said, I don't mind developing the software. But, is the required
>> information easily available? Is there a way to get a diff, something
>> like a list of changed/added/removed files between snapshots?
>
> Your usual diff utility will do it.  I guess you could parse the output of
> btrfs send.
Following this thought, one step closer in getting a text diff can be to 
use fardump. It takes a btrfs send binary stream and outputs the send 
instructions in plaintext. 
(https://kernel.googlesource.com/pub/scm/linux/kernel/git/arne/far-progs).
It certainly would be awesome if btrfs-progs could have an extra 
parameter to just generate the list of changed/added/removed files 
between snapshots as all the needed infrastructure is already in place.

>
>> And, finally, nobody has mentioned on the possibility of merging
>> multiple snapshots into a single snapshot. Would this be possible, to
>> create a snapshot that contains the most recent version of each file
>> present across all of the snapshots (including files which may be
>> present in only one of the snapshots)?
>
> There is no btrfs functionality for that.  But I'm sure you could do something
> with standard Unix utilities and copying files around.
Sure, but the management of data deduplication is left to the user 
(presumably using cp --reflink) which is not trivial.
Does anybody knows how safe it is to use duperemove or bedup?
Any recommendations on how to effectively deduplicate btrfs at this point?
