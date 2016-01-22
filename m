Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38294 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbcAVMHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 07:07:55 -0500
Received: by mail-ig0-f174.google.com with SMTP id mw1so53225861igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 04:07:55 -0800 (PST)
Subject: Re: Kernel 4.4.0 intermittent ENOSPC during heavy data write and
 concurrent snapshotting
To: Roman Mamedov <rm@romanrm.net>, fdmanana@gmail.com
References: <20160120202909.4a804707@natsu>
 <CAL3q7H6y3-8PhZOiBVxszZV5DN-c81EsQ_NjMaHmgGmJrc9aQA@mail.gmail.com>
 <20160121140209.28d0072e@natsu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A21B7A.6070109@gmail.com>
Date: Fri, 22 Jan 2016 07:07:22 -0500
MIME-Version: 1.0
In-Reply-To: <20160121140209.28d0072e@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-21 04:02, Roman Mamedov wrote:
> Hello,
>
> On Wed, 20 Jan 2016 20:46:39 +0000
> Filipe Manana <fdmanana@gmail.com> wrote:
>
>> Try this: https://patchwork.kernel.org/patch/7967161/
>>
>> (It's not a regression in 4.4 however, it has been there for a long time)
>
> I can't reproduce the problem on 4.3.3 or 3.18.22. On 4.4.0 it occurs almost
> instantly (faster if not including 'sync' into the dd cycle).
>
> The patch seems to fix it for 4.4.0, thanks.
>
FWIW, I managed to reproduce it on 4.3.2 just last night, it just takes 
a lot longer to hit than it does in 4.4.0.  I think something might have 
changed that made this more likely to be hit, but I have no idea what.
