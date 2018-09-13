Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726796AbeIMVsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 17:48:09 -0400
Subject: Re: btrfs convert problem
To: Serhat Sevki Dincer <jfcgauss@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
 <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
 <CAPqC6xROL93b5DOrNPaNSZahVKYqSpg0-84DgHsFTQZtHVdnRg@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <10c6a6c5-4d96-30bb-3965-67272d2fe902@suse.com>
Date: Thu, 13 Sep 2018 19:37:50 +0300
MIME-Version: 1.0
In-Reply-To: <CAPqC6xROL93b5DOrNPaNSZahVKYqSpg0-84DgHsFTQZtHVdnRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 19:15, Serhat Sevki Dincer wrote:
>> -1 seems to be EPERM, is your device write-protected, readonly or
>> something like that ?
> 
> I am able to use ext4 partition read/write, created a file and wrote
> in it, un/re mounted it, all is ok.
> The drive only has a microusb port and a little led light; no rw
> switch or anything like that..
> 

What might help is running btrfs convert under strace. So something like :

sudo strace -f -o strace.log btrfs-convert /dev/sdb1 and then send the log.
