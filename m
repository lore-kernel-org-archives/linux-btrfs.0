From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Thu, 02 Jul 2009 17:22:24 +0200
Message-ID: <4A4CD0B0.2080907@wpkg.org>
References: <49EF6DF7.9020406@wpkg.org>	 <1240512313.28015.14.camel@think.oraclecorp.com>	 <49F0FAEA.2020904@wpkg.org> <1240576718.29896.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240576718.29896.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, 2009-04-24 at 01:34 +0200, Tomasz Chmielewski wrote:
>> Chris Mason schrieb:
>>
>>>> However, with btrfs, I'm not sure about:
>>>>
>>>> - what happens if SAN machine crashes while the iSCSI file images were 
>>>> being written to; with LVM and its block devices, I'm somehow more 
>>>> confident it wouldn't make more data loss than necessary
>>> If iscsi is writing with O_DIRECT|O_SYNC it should work.
>> What if it doesn't?
>>
> 
> Writes would go to the page cache only (not O_DIRECT) and the metadata
> wouldn't get flushed with each write (not O_SYNC).

What about the "administrative" part of using btrfs as a volume manager?

For example, I can partition (fdisk + kpartx), extend volumes in LVM 
easily, on the host.


Are there any tools to "partition" or "extend" file images?

qemu-nbd and nbd-client come to mind, but it's a bit of an overhead (in 
typing, I mean).


-- 
Tomasz Chmielewski
http://wpkg.org


