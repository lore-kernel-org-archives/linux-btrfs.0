From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Fri, 24 Apr 2009 01:34:02 +0200
Message-ID: <49F0FAEA.2020904@wpkg.org>
References: <49EF6DF7.9020406@wpkg.org> <1240512313.28015.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240512313.28015.14.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason schrieb:

>> However, with btrfs, I'm not sure about:
>>
>> - what happens if SAN machine crashes while the iSCSI file images were 
>> being written to; with LVM and its block devices, I'm somehow more 
>> confident it wouldn't make more data loss than necessary
> 
> If iscsi is writing with O_DIRECT|O_SYNC it should work.

What if it doesn't?


> But, tuning
> for this config is something we have to concentrate more on.
> 
>> - taking snapshots of individual files (file images on SAN) is not 
>> possible with btrfs? Probably they would have to be placed in separate 
>> directories first to make snapshots - some minor manageability issue
> 
> Btrfs can't snapshot a single dir, but it can snapshot a single file.
> See the bcp command included with btrfs-progs.
> 
> I'd also suggest using preallocated files (via fallocate) instead of
> sparse files.  I will perform better in general.

When performance is needed - sure.


-- 
Tomasz Chmielewski
http://wpkg.org
