Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47141 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaLBN5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 08:57:47 -0500
Received: by mail-pd0-f179.google.com with SMTP id w10so13285942pde.10
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 05:57:46 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v4 00/10] Implement device scrub/replace for RAID56
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1417526902.21136.1@mail.thefacebook.com>
Date: Tue, 2 Dec 2014 21:57:32 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <32AC67B6-DDC6-46FD-94B1-E212855EFE22@gmail.com>
References: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com> <1417526902.21136.1@mail.thefacebook.com>
To: Chris Mason <clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> 
> 
> On Tue, Dec 2, 2014 at 7:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> This patchset implement the device scrub/replace function for RAID56, the
>> most implementation of the common data is similar to the other RAID type.
>> The differentia or difficulty is the parity process. The basic idea is reading
>> and check the data which has checksum out of the raid56 stripe lock, if the
>> data is right, then lock the raid56 stripe, read out the other data in the
>> same stripe, if no IO error happens, calculate the parity and check the
>> original one, if the original parity is right, the scrub parity passes.
>> or write out the new one. But if the common data(not parity) that we read out
>> is wrong, we will try to recover it, and then check and repair the parity.
>> And in order to avoid making the code more and more complex, we copy some
>> code of common data process for the parity, the cleanup work is in my
>> TODO list.
>> We have done some test, the patchset worked well. Of course, more tests
>> are welcome. If you are interesting to use it or test it, you can pull
>> the patchset from
>>  https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace
>> Changelog v3 -> v4:
>> - Fix the problem that the scrub's raid bio was cached, which was reported
>>  by Chris.
>> - Remove the 10st patch, the deadlock that was described in that patch doesn't
>>  exist on the current kernel.
>> - Rebase the patchset to the top of integration branch
> 
> Thanks, I'll try this today.  I need to rebase in a new version of the RCU patches, can you please cook one on top of v3.18-rc6 instead?
> 

BTW, Chris could you please replace with this newer version:
https://patchwork.kernel.org/patch/5359251/

Fengguang reported a build failure regarding this.


> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

