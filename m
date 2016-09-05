Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43477 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753023AbcIEFWN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 01:22:13 -0400
Subject: Re: btrfs send extremely slow (almost stuck)
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
 <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
 <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2ae7659b-ebb2-200b-174e-9ca186cb22cd@cn.fujitsu.com>
Date: Mon, 5 Sep 2016 13:21:58 +0800
MIME-Version: 1.0
In-Reply-To: <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/05/2016 05:41 AM, Oliver Freyermuth wrote:
> Am 30.08.2016 um 02:48 schrieb Qu Wenruo:
>> Yes.
>> And more specifically, it doesn't even affect delta backup.
>>
>> For shared extents caused by reflink/dedupe(out-of-band or even incoming in-band), it will be send as individual files.
>>
>> For contents, they are all the same, just more space usage.
>
> For those interested, I have now actually tested the btrfs send / btrfs receive backup for several subvolumes after applying this patch.
> The throughput is finally usable, almost hitting network / IO limits as expected - ideal so far!
> Also delta seemed fine for the subvolumes for which things worked.
>
> However, I now sadly get (for one of my subvolumes):
>
> send ioctl failed with -2: No such file or directory
>
> at some point during the transfer, it sadly seems to be reproducible.
> I do not think it's related to this patch, but of course this makes "btrfs send" still unusable to me -
> I guess it's not ready for general use just yet.
> Is there any information I can easily extract / provide to allow the experts to fix this issue?

Did you get the half way send stream?

If the send stream has something, please use "--no-data" option to send 
the subvolume again to get the metadata only dump, and upload it for debug.

Also, please paste "btrfs-debug-tree -t <your subvolume id>" output for 
debug.
WARN: above "btrfs-debug-tree" command will contain file names.
You could use the following sed to wipe filename:

"btrfs-debug-tree  -t 5 /dev/sda6  | sed "s/name:.*//"

Thanks,
Qu

> The kernel log shows nothing.
>
> Thanks a lot,
> 	Oliver
>
>


