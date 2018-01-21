Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:36066 "EHLO
        postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbeAUWeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 17:34:03 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
 <CAJCQCtQOTNZZnkiw2Tq9Mgwnc4pykbOjCb2DCOm4iCjn5K9jQw@mail.gmail.com>
From: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Message-ID: <5e705af4-2bd7-6e3e-2179-a957a81275fc@cs.uni-bonn.de>
Date: Sun, 21 Jan 2018 23:33:59 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQOTNZZnkiw2Tq9Mgwnc4pykbOjCb2DCOm4iCjn5K9jQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21.01.2018 23:04, Chris Murphy wrote:
> On Sun, Jan 21, 2018 at 8:27 AM, Sebastian Ochmann
> <ochmann@cs.uni-bonn.de> wrote:
>> On 21.01.2018 11:04, Qu Wenruo wrote:
> 
>> The output of "mount" after setting 10 seconds commit interval:
>>
>> /dev/sdc1 on /mnt/rec type btrfs
>> (rw,relatime,space_cache,commit=10,subvolid=5,subvol=/)
> 
> I wonder if it gets stuck updating v1 space cache. Instead of trying
> v2, you could try nospace_cache mount option and see if there's a
> change in behavior.

I tried disabling space_cache, also on a newly formatted volume when 
first mounting it. However, it doesn't seem to make a difference. 
Basically the same lags in the same interval, sorry.

Best regards
Sebastian
