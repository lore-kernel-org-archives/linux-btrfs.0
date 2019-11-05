Return-Path: <SRS0=ssiY=Y5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5974ACA9ED3
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDA320717
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="moFy8iaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfKEArx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:47:53 -0500
Received: from mail.virtall.com ([46.4.129.203]:54668 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfKEArw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Nov 2019 19:47:52 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 98AA537F551E;
        Tue,  5 Nov 2019 00:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1572914869; bh=pWCv3AQfJFQLDhG5EZKePXNFlXHS1A4lrFLs7N+qhNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=moFy8iaKMeLH4go2aOrWcTGGUoKeLWFacfzh08Fy9JCBYEgkceSgaYBf0Digj1le8
         oNQq/kI9V8VRRw9Jx5PDz/emtp9Lf1LzujqSSDPHJmKusHd5jekGnFlIWRP6xT2b01
         efYJS2YHxvjytvQWYTeLHCULVh+PnyzddxMMLr3TfCcquFnke3i62eOVTPul8Z99eD
         vEu+lX3TWtM1li7naUpqJ1D/G53lcPL1PoK4mtPT1Hz5NkBLP+XS/CTZBcgHVxdrY4
         ui9BzwLLcNZu1NusFAnSaNZlpCmyIFMNRQJ4Tl9MsdI9Hz4oD9nAn7/GklM1n2U0zW
         XmnzMORrqy5RA==
X-Fuglu-Suspect: 73d140f447ce4b83b977ca02aafefbc2
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Tue,  5 Nov 2019 00:47:48 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Nov 2019 09:47:48 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: CPU: 6 PID: 13386 at fs/btrfs/ctree.h:1593
 btrfs_update_device.cold+0x10/0x1b [btrfs]
In-Reply-To: <d24256c7-4398-7627-4352-1878af1467e9@gmx.com>
References: <0a25bc52b9d3649d499b76d06e0d117b@wpkg.org>
 <d24256c7-4398-7627-4352-1878af1467e9@gmx.com>
Message-ID: <94c49648ea714dcd1f087f24ee796115@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-11-02 12:38, Qu Wenruo wrote:
> On 2019/11/2 上午9:13, Tomasz Chmielewski wrote:
>> I'm getting these recently from time to time (first noticed in 5.3.x,
>> but maybe they were showing up before and I didn't notice).
>> 
>> Everything seems to work fine so far. Anything to worry about?
> 
> This is a warning about unaligned device size.
> 
> You can either fix it by reducing the device size by 4K for each 
> device,
> or use btrfs rescue fix-dev-size unmounted to repair.

Unfortunately "btrfs rescue fix-device-size" doesn't seem to help. I'm 
still seeing these entries in dmesg some time after using the command.

Also:

# umount /home

# btrfs rescue fix-device-size /dev/sdb4
Fixed device size for devid 2, old size: 3950855921152 new size: 
3950855917568
Fixed device size for devid 3, old size: 3950855921152 new size: 
3950855917568
Fixed super total bytes, old size: 7901711842304 new size: 7901711835136
Fixed unaligned/mismatched total_bytes for super block and device items

# btrfs rescue fix-device-size /dev/sdb4
No device size related problem found

# btrfs rescue fix-device-size /dev/sda4
No device size related problem found

# dmesg -c

# mount /home


Now let's try to unmount and see what "btrfs rescue fix-device-size" 
shows again - I'd expect "No device size related problem found", 
correct?


# umount /home

# btrfs rescue fix-device-size /dev/sda4
parent transid verify failed on 265344253952 wanted 42646 found 46119
parent transid verify failed on 265344253952 wanted 42646 found 46119
parent transid verify failed on 265344253952 wanted 42646 found 46119
Ignoring transid failure
Fixed super total bytes, old size: 7901711842304 new size: 7901711835136
Fixed unaligned/mismatched total_bytes for super block and device items

# btrfs rescue fix-device-size /dev/sda4
No device size related problem found

# btrfs rescue fix-device-size /dev/sdb4
No device size related problem found

# mount /home ; umount /home

# btrfs rescue fix-device-size /dev/sdb4
parent transid verify failed on 265344253952 wanted 42646 found 46119
parent transid verify failed on 265344253952 wanted 42646 found 46119
parent transid verify failed on 265344253952 wanted 42646 found 46119
Ignoring transid failure
Fixed super total bytes, old size: 7901711842304 new size: 7901711835136
Fixed unaligned/mismatched total_bytes for super block and device items

# mount /home



Tomasz Chmielewski
https://lxadm.com
