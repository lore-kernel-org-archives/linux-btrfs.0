From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Creation of pseudo items leads to (seemingly) duplicate inodes
 (BUG inside)
Date: Wed, 19 Oct 2011 12:07:38 +0200
Message-ID: <4E9EA16A.6040105@jan-o-sch.net>
References: <4E9DA301.5050907@jan-o-sch.net> <4E9E2177.6050405@cn.fujitsu.com> <4E9E2550.1050503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9E2550.1050503@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>



On 19.10.2011 03:18, Liu Bo wrote:
> On 10/19/2011 09:01 AM, Liu Bo wrote:
>> On 10/19/2011 12:02 AM, Jan Schmidt wrote:
>>> Hi there,
>>>
>>> while playing with snapshots for btrfs send, I also encountered
>>> seemingly duplicate inodes, which are multiple
>>> BTRFS_EMPTY_SUBVOL_DIR_OBJECTID objects within the same directory. I can
>>> imagine software that feels uncomfortable, here.
>>>
>>> Such objects are created by btrfs_lookup_dentry() in fs/btrfs/inode.c
>>> when ENOENT is encountered.
>>>
>>
>> Hi,
>>
>> A similar bug has been fixed by one of my patches(still queued):
>>
> 
> sorry, I missed something, this one has been merged in Chris's github tree(for rc6).

Thanks for pointing me there, now I see why I fail to trigger the bug.

-Jan

>> http://marc.info/?l=linux-btrfs&m=131409014207238&w=2
>>
>> thanks,
>> liubo
