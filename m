From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 13:12:14 +0200
Message-ID: <4D94618E.3030300@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: sensille@gmx.net, larry@elder-gods.org, hch@infradead.org
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen wrote:

>> On Thu, Mar 31, 2011 at 12:00:11AM -0400, Larry D'Anna wrote:
>>> This is a simple patch to allow reflinks to be made crossing subvolume
>>> boundaries.
>>
>> NAK.  subvolumes will have to become vfsmounts sooner or later, and we
>> really must not support any operations spanning mountpoints.
>
> In what way would this interfere? the reflinked file gets its own inum
> in its own mountpoint. The two files only internally share some disk
> space.

Similarly, it would be pity if proposed deduplication couldn't cross 
subvolume boundaries...


-- 
Tomasz Chmielewski
http://wpkg.org

