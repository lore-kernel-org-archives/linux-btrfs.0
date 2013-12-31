Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:42667 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3LaS1b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Dec 2013 13:27:31 -0500
Received: by mail-ig0-f177.google.com with SMTP id uy17so30338084igb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 10:27:29 -0800 (PST)
Message-ID: <52C30C8E.9020103@gmail.com>
Date: Tue, 31 Dec 2013 13:27:26 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question regarding caching
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
In-Reply-To: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/30/2013 09:24 PM, Aastha Mehta wrote:
> Hello,
> 
> I have some questions regarding caching in BTRFS. When a file
> system is unmounted and mounted again, would all the previously
> cached content be removed from the cache after flushing to disk?
> After remounting, would the initial requests always be fetched from
> the disk?
> 
> Rather than a local disk, I have a remote device to which my IO 
> requests are sent and from which the data is fetched. I need
> certain data to be fetched from the remote device after a remount.
> But somehow I do not see any request appearing at the device. I
> even tried to do drop_caches after remounting the file system, but
> that does not seem to help.
> 
> I guess my problem is not related to BTRFS, but since I am working 
> with BTRFS, I wanted to ask here for help. Could any one tell me
> how I can ensure that requests are fetched from the (remote)
> device, especially after file system remount, without having to
> use drop_caches?
> 
> Please let me know if I described the problem too vaguely and
> should give some more details.
The data is probably still cached in the block layer, so after
unmounting, you could try 'echo 1 > /proc/sys/vm/drop_caches' before
mounting again, but make sure to run sync right before doing that,
otherwise you might lose data.
