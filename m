Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36299 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdDJMvt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:51:49 -0400
Received: by mail-io0-f172.google.com with SMTP id l7so93532040ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 05:51:49 -0700 (PDT)
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
Date: Mon, 10 Apr 2017 08:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20170410144533.664fc304@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-10 08:45, Kai Krakow wrote:
> Am Mon, 10 Apr 2017 08:39:23 -0400
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> They've been running BTRFS
>> with LZO compression, the SSD allocator, atime disabled, and mtime
>> updates deferred (lazytime mount option) the whole time, so it may be
>> a slightly different use case than the OP from this thread.
>
> Does btrfs really support lazytime now?
>
It appears to, I do see fewer writes with it than without it.  At the 
very least, if it doesn't, then nothing complains about it.
