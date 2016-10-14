Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34988 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcJNL2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 07:28:09 -0400
Received: by mail-io0-f174.google.com with SMTP id i202so117058803ioi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 04:28:09 -0700 (PDT)
Subject: Re: Unable to rescue RAID5
To: Hiroshi Honda <xero@incoming.jp>, Duncan <1i5t5.duncan@cox.net>
References: <20161013102819.214E.13A92CCA@incoming.jp>
 <pan$b3ec1$5f43718$b476c91b$81bb21ae@cox.net>
 <20161014191141.2154.13A92CCA@incoming.jp>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0b965ca4-014b-33f2-295b-a02feb0d7ccb@gmail.com>
Date: Fri, 14 Oct 2016 07:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <20161014191141.2154.13A92CCA@incoming.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-14 06:11, Hiroshi Honda wrote:
>> That's the proper answer.  In practice... all hope isn't yet lost.
> I understood the proper answer.
> I'll take care it in the future.
>
> Is there something step/method can I do from this situation?
>
You should probably look at `btrfs restore`.  I'm not sure how well it 
works with the raid56 code, and you'll need somewhere to put the data 
being restored, but that's probably your best option.

