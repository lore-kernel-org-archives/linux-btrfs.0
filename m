Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:49443 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3EIHt6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 03:49:58 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so3228104qae.6
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 00:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518B533A.7020503@giantdisaster.de>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
	<CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
	<518B4274.3020000@giantdisaster.de>
	<CAEH94LiBzA0SEg+TKRs8_MP43UEDq6ULU2WfjYmAMhneHRZKpw@mail.gmail.com>
	<518B533A.7020503@giantdisaster.de>
Date: Thu, 9 May 2013 15:49:56 +0800
Message-ID: <CAEH94LgZa8htP=4R=VchFAdmGm43=TTWCHUZxx1AKX2ixKvaUA@mail.gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No, no, you misunderstood what i mean.:)  You know, it will perhaps
take a lot of time to do some benchmark. We only hope to get some
suggestion about if it should be worth to continue working on. Very
welcome to your and other guys' opinions.

On Thu, May 9, 2013 at 3:41 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On 05/09/2013 08:42, Zhi Yong Wu wrote:
>>
>> btrfs maintainer's opinion is very important, i guess.
>
>
> My opinion is not important and I shall shut up?
>
>
>
>> On Thu, May 9, 2013 at 2:30 PM, Stefan Behrens
>> <sbehrens@giantdisaster.de> wrote:
>>>
>>> On 05/09/2013 01:13, Zhi Yong Wu wrote:
>>>>
>>>>
>>>> HI, all
>>>>
>>>>      I saw that bcache will be merged into kernel upstream soon, so i
>>>> want to know if btrfs hot relocation support is still meanful, if no,
>>>> i will not continue to work on it. can anyone let me know this?
>>>> thanks.
>>>
>>>
>>>
>>> Which one is better?
>>>
>>> Please do some measurements. Select typical file system use cases, and
>>> publish and compare the measurement results of the two approaches.
>
>



-- 
Regards,

Zhi Yong Wu
