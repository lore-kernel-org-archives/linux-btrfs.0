Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33375 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760917AbdDSJo2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 05:44:28 -0400
Received: by mail-qk0-f181.google.com with SMTP id h67so15310787qke.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Apr 2017 02:44:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2e30c414-3bb3-536e-2bab-1bbda9cba25d@cn.fujitsu.com>
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de> <2e30c414-3bb3-536e-2bab-1bbda9cba25d@cn.fujitsu.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Wed, 19 Apr 2017 11:44:27 +0200
Message-ID: <CAPmG0jZH3K+skMjROAUtRyhsRbah4Pbcx8JmNKc7bn+mLn2tUQ@mail.gmail.com>
Subject: Re: btrfs check --check-data-csum malfunctioning?
To: Werner Braun <wb@o3-software.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> At 04/18/2017 08:41 PM, Werner Braun wrote:
>>
>> Hi,
>>
>> i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs scrub
>>
>> running btrfs check --check-data-csum returns no errors on the disk
>>
>> running btrfs scrub on the disk finds tons of errors
>>
>> i could clear the disk and send it to anyone intrested in ;-)
>>
>>
> That's because --check-data-csum will only check the first copy of data if
> the first copy is good.

So is the conclusion that all the csum errors are in the metadata?
What is the profile of the fs? ( not dup for metadata I assume?)

I also have a WD40EZRX and the fs on it is also almost exclusively a
btrfs receive target and it has now for the second time csum (just 5 )
errors. Extended selftest at 16K hours shows no problem and I am not
fully sure if this is a magnetic media error case or something else.
