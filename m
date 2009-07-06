From: Chris Mason <chris.mason@oracle.com>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Mon, 6 Jul 2009 14:51:53 -0400
Message-ID: <20090706185153.GC4092@think>
References: <49EF6DF7.9020406@wpkg.org> <1240512313.28015.14.camel@think.oraclecorp.com> <49F0FAEA.2020904@wpkg.org> <1240576718.29896.2.camel@think.oraclecorp.com> <4A4CD0B0.2080907@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A4CD0B0.2080907@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 02, 2009 at 05:22:24PM +0200, Tomasz Chmielewski wrote:
> Chris Mason wrote:
>> On Fri, 2009-04-24 at 01:34 +0200, Tomasz Chmielewski wrote:
>>> Chris Mason schrieb:
>>>
>>>>> However, with btrfs, I'm not sure about:
>>>>>
>>>>> - what happens if SAN machine crashes while the iSCSI file images 
>>>>> were being written to; with LVM and its block devices, I'm 
>>>>> somehow more confident it wouldn't make more data loss than 
>>>>> necessary
>>>> If iscsi is writing with O_DIRECT|O_SYNC it should work.
>>> What if it doesn't?
>>>
>>
>> Writes would go to the page cache only (not O_DIRECT) and the metadata
>> wouldn't get flushed with each write (not O_SYNC).
>
> What about the "administrative" part of using btrfs as a volume manager?

In this case it depends on exactly how you do it.  If you're just using
files and putting filesystems on those files (not partitioning inside
the image), then you can use truncate to shrink the image and fallocate
(or truncate if you want it sparse) to extend it.

If you want to make partition tables inside the volumes, then you need
to do the truncate/fallocate game and also change the partition table.

-chris
