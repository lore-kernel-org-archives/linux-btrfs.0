Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56890 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751665AbcKRCGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 21:06:25 -0500
Subject: Re: root backup-reformat-restore
To: Hugo Mills <hugo@carfax.org.uk>
References: <7ef59dd2-fbfb-055a-3f5b-b11cc03f4cce@iki.fi>
 <20161118005253.GY16645@carfax.org.uk>
From: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <29627979-aaef-6f9e-d3b0-3f69333993f9@iki.fi>
Date: Fri, 18 Nov 2016 04:06:22 +0200
MIME-Version: 1.0
In-Reply-To: <20161118005253.GY16645@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18.11.2016 02:52, Hugo Mills wrote:
> On Fri, Nov 18, 2016 at 02:38:25AM +0200, Marcus Sundman wrote:
>> The FAQ says that "the best solution for small devices (under about
>> 16 GB) is to reformat the FS with the --mixed option to mkfs.btrfs".
>>
>> OK. Does anyone have any good suggestions for doing that with an
>> existing / partition (which has special files and whatnot)?
>>
>> I assume a backup-restore cycle is needed, but with which program(s)?
>   - If you don't have (or don't care about) any snapshots, then
>      - if you can mount both the old and the new FS at the same time
>         - mv

It's the same partition, so I probably won't have the new FS there at 
the same time.

>      - else, if you want to replace the old FS with the new
>         - tar to a file elsewhere, and untar later

Can tar really preserve all special files' attributes? (I have separate 
partitions for /boot and /home, but the rest is in /)

Thanks!
