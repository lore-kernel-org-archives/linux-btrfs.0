Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36541 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbdBHMhZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 07:37:25 -0500
Received: by mail-io0-f195.google.com with SMTP id q20so15688290ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 04:37:24 -0800 (PST)
Subject: Re: [PATCH] btrfs-progs: better document btrfs receive security
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170203134858.75210-1-ahferroin7@gmail.com>
 <20170207182713.GD3366@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b5e64d04-a992-afcf-55ef-e1ab0a702a71@gmail.com>
Date: Wed, 8 Feb 2017 07:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <20170207182713.GD3366@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 13:27, David Sterba wrote:
> On Fri, Feb 03, 2017 at 08:48:58AM -0500, Austin S. Hemmelgarn wrote:
>> This adds some extra documentation to the btrfs-receive manpage that
>> explains some of the security related aspects of btrfs-receive.  The
>> first part covers the fact that the subvolume being received is writable
>> until the receive finishes, and the second covers the current lack of
>> sanity checking of the send stream.
>>
>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
> Applied, thanks.
>
Didn't get a chance to mention this yesterday, but it looks like you 
hadn't seen the updated version I sent on the third.  Message ID is:
<20170203193805.96977-1-ahferroin7@gmail.com>

The only significant difference is that I updated the description for 
the writablility issue using a much better description from Graham Cobb 
(with his permission of course).

If you want, I can send an incremental patch on top of the original to 
update just that description.
