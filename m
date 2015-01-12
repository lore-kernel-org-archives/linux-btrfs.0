Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:52953 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbALPLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 10:11:32 -0500
Received: by mail-yk0-f170.google.com with SMTP id 200so9388252ykr.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 07:11:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B3E03E.80606@gmail.com>
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
	<54B3E03E.80606@gmail.com>
Date: Mon, 12 Jan 2015 16:11:32 +0100
Message-ID: <CAA7pwKN0-EtPA7Z+2AKSSzOqBOpUGETFFxm-U0umQcAzOkNxYA@mail.gmail.com>
Subject: Re: btrfs performance - ssd array
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 January 2015 at 15:54, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> Another thing to consider is that the kernel's default I/O scheduler and the default parameters for that I/O scheduler are almost always suboptimal for SSD's, and this tends to show far more with BTRFS than anything else.  Personally I've found that using the CFQ I/O scheduler with the following parameters works best for a majority of SSD's:
> 1. slice_idle=0
> 2. back_seek_penalty=1
> 3. back_seek_max set equal to the size in sectors of the device
> 4. nr_requests and quantum set to the hardware command queue depth
>
> You can easily set these persistently for a given device with a udev rule like this:
>   KERNEL=='sda', SUBSYSTEM=='block', ACTION=='add', ATTR{queue/scheduler}='cfq', ATTR{queue/iosched/back_seek_penalty}='1', ATTR{queue/iosched/back_seek_max}='<device_size>', ATTR{queue/iosched/quantum}='128', ATTR{queue/iosched/slice_idle}='0', ATTR{queue/nr_requests}='128'
>
> Make sure to replace '128' in the rule with whatever the command queue depth is for the device in question (It's usually 128 or 256, occasionally more), and <device_size> with the size of the device in kibibytes.
>

So is it "size in sectors of the device" or "size of the device in
kibibytes" for back_seek_max? :-)
