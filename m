Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:32777 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753348AbdAZJg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 04:36:59 -0500
Received: by mail-wj0-f193.google.com with SMTP id un2so4245697wjb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jan 2017 01:36:58 -0800 (PST)
Subject: Re: btrfs recovery
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
Date: Thu, 26 Jan 2017 10:36:55 +0100
MIME-Version: 1.0
In-Reply-To: <20170126092559.GD24076@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi and thanks for the quick reply! 

Am 26.01.2017 um 10:25 schrieb Hugo Mills:
>    Can you post the output of "btrfs-debug-tree -b 35028992
> /dev/sdb1", specifically the 5 or so entries around item 243. It is
> quite likely that you have bad RAM, and the output will help confirm
> that.
> 

Since I did not find item 243 in the debug output at all, I uploaded the complete output of the debug-tree command here:
http://pastebin.com/xM8qUnSx

>    Check and fix your hardware first. :)
> 
>    If it is bad RAM, then the error is likely to be a simple bitflip,
> and there are patches for btrfs check which will fix those in most
> cases.

I'll schedule a memcheck as soon as I can turn off the machine for a while,
which sadly may be a week or so in the future from now... 

> 
>    Hugo.
> 
>> Cheers and thanks for any suggestions, 
>> 	Oliver
>>
>> PS: Please put my mail in CC, I'm not subscribed to the list. Thanks! 
> 
