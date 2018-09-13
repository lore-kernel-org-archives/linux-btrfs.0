Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:34461 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbeINE3S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:29:18 -0400
Subject: Re: btrfs convert problem
To: Nikolay Borisov <nborisov@suse.com>,
        Serhat Sevki Dincer <jfcgauss@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
 <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
 <CAPqC6xROL93b5DOrNPaNSZahVKYqSpg0-84DgHsFTQZtHVdnRg@mail.gmail.com>
 <10c6a6c5-4d96-30bb-3965-67272d2fe902@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0af846d3-9f07-d744-f9e4-862fc5a0cbad@gmx.com>
Date: Fri, 14 Sep 2018 07:17:30 +0800
MIME-Version: 1.0
In-Reply-To: <10c6a6c5-4d96-30bb-3965-67272d2fe902@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/14 上午12:37, Nikolay Borisov wrote:
> 
> 
> On 13.09.2018 19:15, Serhat Sevki Dincer wrote:
>>> -1 seems to be EPERM, is your device write-protected, readonly or
>>> something like that ?
>>
>> I am able to use ext4 partition read/write, created a file and wrote
>> in it, un/re mounted it, all is ok.
>> The drive only has a microusb port and a little led light; no rw
>> switch or anything like that..
>>
> 
> What might help is running btrfs convert under strace. So something like :
> 
> sudo strace -f -o strace.log btrfs-convert /dev/sdb1 and then send the log.
> 
strace would greatly help in this case.

My guess is something wrong happened in migrate_super_block(), which
doesn't handle ret > 0 case well.
In that case, it means pwrite 4K doesn't finish in one call, which looks
pretty strange.

Thanks,
Qu
