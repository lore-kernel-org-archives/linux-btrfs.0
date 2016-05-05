Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36354 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcEELXU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2016 07:23:20 -0400
Received: by mail-io0-f181.google.com with SMTP id u185so93546184iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 May 2016 04:23:20 -0700 (PDT)
Subject: Re: Spare volumes and hot auto-replacement feature
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <572A8337.1030505@mail.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <008f1f81-df20-796f-a609-78075ddd9837@gmail.com>
Date: Thu, 5 May 2016 07:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <572A8337.1030505@mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-04 19:18, Dmitry Katsubo wrote:
> Dear btrfs community,
>
> I am interested in spare volumes and hot auto-replacement feature [1]. I have a couple of questions:
>
> * Which kernel version this feature will be included?
Probably 4.7.  I would not suggest using it in production for at least a 
few cycles though (probably 4.9).
> * The description says that replacement happens automatically when there is any write failed or flush failed. Is it possible to control the ratio / number of such failures? (e.g. in case it was one-time accidental failure)
As far as I know, no, it just happens.
> * What happens if spare device is smaller then the (failing) device to be replaced?
I'm pretty sure that it doesn't get replaced.
> * What happens if during the replacement the spare device fails (write error)?
I'm not certain about this one.
> * Is it possible for root to be notified in case if drive replacement (successful or unsuccessful) took place? Actually this question is actual for me for overall write/flush failures on btrfs volume (btrfs monitor).
There isn't any built-in monitoring in BTRFS that I know of, there are a 
couple of options though for monitoring.  The simplest and probably most 
reliable is to write a script to poll for changes in the error counts. 
You can also check the filesystem mount options (without the hot-spare 
functionality, if there's an error, the filesystem will (usually) get 
remounted read-only, and this also works for most other filesystems too).
