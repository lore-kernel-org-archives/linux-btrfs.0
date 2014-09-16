Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:42954 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbaIPTyn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 15:54:43 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTypl-0002IF-RT
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 15:54:41 -0400
Message-ID: <54189581.6050303@intellasoft.net>
Date: Tue, 16 Sep 2014 15:54:41 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance enospc
References: <54186A4B.60902@intellasoft.net> <54186A82.7070801@intellasoft.net> <5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com>
In-Reply-To: <5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The smart stats on the disk are fine.  The /dev/sdc messages are from me 
playing around and pulling out the drive.   btrfs fi show, shows the 
drive as missing, yet it's still trying to write to it.

Basically my goal is to remove this drive and stick it in another box 
and I can't get btrfs to move all the data off of it due to enospc.

I'm gonna try and move some data off and remove/balance again.


On 09/16/14 13:26, Chris Murphy wrote:
 > Better to use btrfs replace. But sequence wise you should do btrfs 
device delete missing, which should then effectively do a balance to the 
newly added device. So while the sequence isn't really correct, that's 
probably not why you're getting this failure.
 >
 >
 >
 >>
 >>
 >> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2411,
 >> rd 0, flush 38, corrupt 137167, gen 25
 >
 > Please post results of
 > smartctl -x /dev/sdc
 >

 > I'd expect with Btrfs having problems writing to a device, that 
there'd be libata messages related to this also. Do you have earlier 
kernel messages indicating the drive or controller are reporting errors?
 >
 >

