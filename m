Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60078 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJKPLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 11:11:11 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so4567549lbg.32
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Oct 2014 08:11:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141011085216.GA29666@localhost.localdomain>
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
	<20141007020538.GA3187@localhost.localdomain>
	<54334D5E.9000300@shroop.net>
	<20141008142030.GA13823@localhost.localdomain>
	<543562C6.3030604@shroop.net>
	<20141009071337.GA13470@localhost.localdomain>
	<5436BE9B.90300@shroop.net>
	<20141011085216.GA29666@localhost.localdomain>
Date: Sat, 11 Oct 2014 08:11:10 -0700
Message-ID: <CAG+QAKVJNojVW-tZ61_J9Gff9hK_xkVViX8dzp65waiovf_JRQ@mail.gmail.com>
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
From: Rich Rauenzahn <rrauenza@gmail.com>
To: bo.li.liu@oracle.com
Cc: Rich Rauenzahn <rich@shroop.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ sudo ./btrfs-debug-tree  /dev/sdf3 | grep 58464632832
                namelen 11 datalen 0 name: 58464632832
                namelen 11 datalen 0 name: 58464632832
                inode ref index 266598 namelen 11 name: 58464632832

Is that a real inode number? I think it isn't ... Wait -- I think I'm
picking a file in /tmp with that name, which is a block I dumped.
Renamed it.

$ sudo ./btrfs-debug-tree  /dev/sdf3 | grep 58464632832

Now it returns nothing...


On Sat, Oct 11, 2014 at 1:52 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Oct 09, 2014 at 09:58:03AM -0700, Rich Rauenzahn wrote:
>> On 10/9/2014 12:13 AM, Liu Bo wrote:
>> >sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /
>>
>> $ sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /
>> ioctl ret=0, total_size=4096, bytes_left=4080, bytes_missing=0,
>> cnt=0, missed=0
>
> Hi Rich,
>
> So cnt=0 is the reason that we got nothing output, however,
> to be honest, I don't know exactly why 'cnt' is 0, perhaps it's due to an old
> version btrfs, as the 'btrfs inspect-internal' command depends on ioctl which
> may have bugs in old btrfs.
>
>>
>> I also tried -P and -s 100000000 ....
>>
>> Also did this:
>>
>> $ sudo ./btrfs-map-logical  -l 58464632832   -o /tmp/58464632832 /dev/sdf3
>> mirror 1 logical 58464632832 physical 1536393216 device /dev/sdg3
>> mirror 2 logical 58464632832 physical 58464632832 device /dev/sdf3
>>
>> And looked at the 4k block.  strings doesn't show anything useful: +V0T"
>> File doesn't recognize it as anything particular.
>>
>> Weird.
>
> One ultimate solution is to use 'btrfs-debug-tree' to dump the human readable
> metadata information and grep for 58464632832 to read inode info. ,
> but this may cost time depending on the size of your patition.
>
> thanks,
> -liubo
>
>>
>> I have one other clue which I think is irrelevant.  I had another
>> error on a different drive/different fs and it turned out to be the
>> vmem file for a virtual machine under vmware workstation.  I deleted
>> the file since it was just the memory image and the error went away.
>> It was easy to map the bad block to the file from dmesg and the
>> inode.   I may have also created a vm at some point on this drive
>> we're looking at now and then moved it.  So I think that information
>> is not relevant... but maybe you've seen this before.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
