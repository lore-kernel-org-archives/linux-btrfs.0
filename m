Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20111 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758567AbdDSAlA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 20:41:00 -0400
Subject: Re: btrfs check --check-data-csum malfunctioning?
To: Werner Braun <wb@o3-software.de>, <linux-btrfs@vger.kernel.org>
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2e30c414-3bb3-536e-2bab-1bbda9cba25d@cn.fujitsu.com>
Date: Wed, 19 Apr 2017 08:40:54 +0800
MIME-Version: 1.0
In-Reply-To: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/18/2017 08:41 PM, Werner Braun wrote:
> Hi,
> 
> i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs scrub
> 
> running btrfs check --check-data-csum returns no errors on the disk
> 
> running btrfs scrub on the disk finds tons of errors
> 
> i could clear the disk and send it to anyone intrested in ;-)
> 
> 
That's because --check-data-csum will only check the first copy of data 
if the first copy is good.

I've submitted offline scrub patchset to address this, which is a 
btrfs-progs equivalent of kernel scrub.

https://github.com/adam900710/btrfs-progs/tree/offline_scrub

Thanks,
Qu


