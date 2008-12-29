From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: multiple device usage
Date: Mon, 29 Dec 2008 20:33:18 +0800
Message-ID: <3d0408630812290433r7f2bb07cue3239c8acf958bb3@mail.gmail.com>
References: <556243856@web.de> <200812271745.45860.chris@csamuel.org>
	 <200812292232.08037.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Samuel" <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812292232.08037.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2008/12/29 Chris Samuel <chris@csamuel.org>:
> On Sat, 27 Dec 2008 5:45:42 pm Chris Samuel wrote:
>
>> I'll add two questions that're not answered by the Wiki too.. :-)
>
> Looking at the source implies to me:
>
>> 1) If you add a second disk to an existing btrfs filesystem, can you get it
>> to set it up as a RAID-1 arrangement rather than just rebalancing the
>> metadata and then striping ?
>
> No, you can't, the data stripe numbers seem to be set at mkfs time.
>
> The rebalancing code does appear (from a naive read of the code) to be able to
> rebalance over stripes, but I have no idea if the disk format currently
> supports changing that on the fly.
>

The rebalancing moves data/metadata to newly created chunks. If there
are two devices, the new chunks will be set up as RAID-1 by default.

>> 2) With the concerns that people have about SSD reliability (hi Val :-) !)
>> would it make sense to set up two equal sized partitions on the SSD and use
>> RAID-1 across them, or can you tell btrfs to keep multiple copies of the
>> data, a la ZFS ?
>
> Again it would appear that you need to have two partitions and that btrfs
> cannot (at present) keep multiple data stripes on the same partition.
>

Yes. I think this is due to performance reason. Changing the code to
support data duplication in single spindle configuration is easy.

Regards
Yan Zheng
