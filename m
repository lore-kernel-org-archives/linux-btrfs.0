Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2JIGrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 02:47:11 -0400
Message-ID: <5073BDAE.7090908@cn.fujitsu.com>
Date: Tue, 09 Oct 2012 14:01:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 0/7 ] Btrfs-progs: enhance btrfs subvol list only to
 show read-only snapshots
References: <50584E6D.8000602@cn.fujitsu.com> <20121003000304.GH3214@shiny>
In-Reply-To: <20121003000304.GH3214@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Oct 2012 20:03:04 -0400, Chris Mason wrote:
> On Tue, Sep 18, 2012 at 04:35:25AM -0600, Miao Xie wrote:
>> We want 'btrfs subvolume list' only to list readonly subvolumes, this patch set
>> introduces a new option 'r' to implement it.
>>
>> You can use the command like that:
>>
>> 	btrfs subvolume list -r <mnt>
>>
>> Changelog v3 -> v4:
>> - modify the check method which is used to check if btrfs_root_item contains otime and uuid
>>   or not.
>> - add filter set and comparer set which are used to manage the filters and comparers specified
>>   by the users.
>> - re-base the read-only subvolume list function.
>>
>> Changelog v2 -> v3:
>> - re-implement list_subvols()
>> - re-implement this read-only subvolume list function based on the new list_subvols()
>>
>> Changelog v1 -> v2:
>> - address the comments from Goffredo Baroncelli
>>   i,   change the changelog of the patches and make them more elaborate.
>>   ii,  move the function declarations to a new head file.
>>   iii, add the introduction of the new option 'r' into the man page
>>
>> We can pull the patches from the URL
>>
>> 	git://github.com/miaoxie/btrfs-progs.git master
>>
>> This patchset is against the patches of Liu Bo, Anand Jain and mine which were sent by several
>> days ago. And we also can pull those patches from the above URL.
> 
> These are all really useful additions!  How do you plan on using the
> table option? (just curious).

It is just used to make the output be read easily. The old output always throw
out lots of inessential repeated strings, it is very ugly and make us giddy. So
we add this option to make the users happy.

Thanks
Miao
