Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:34809 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3EIHlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 03:41:19 -0400
Message-ID: <518B533A.7020503@giantdisaster.de>
Date: Thu, 09 May 2013 09:41:46 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>
CC: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com> <518B4274.3020000@giantdisaster.de> <CAEH94LiBzA0SEg+TKRs8_MP43UEDq6ULU2WfjYmAMhneHRZKpw@mail.gmail.com>
In-Reply-To: <CAEH94LiBzA0SEg+TKRs8_MP43UEDq6ULU2WfjYmAMhneHRZKpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2013 08:42, Zhi Yong Wu wrote:
> btrfs maintainer's opinion is very important, i guess.

My opinion is not important and I shall shut up?


> On Thu, May 9, 2013 at 2:30 PM, Stefan Behrens
> <sbehrens@giantdisaster.de> wrote:
>> On 05/09/2013 01:13, Zhi Yong Wu wrote:
>>>
>>> HI, all
>>>
>>>      I saw that bcache will be merged into kernel upstream soon, so i
>>> want to know if btrfs hot relocation support is still meanful, if no,
>>> i will not continue to work on it. can anyone let me know this?
>>> thanks.
>>
>>
>> Which one is better?
>>
>> Please do some measurements. Select typical file system use cases, and
>> publish and compare the measurement results of the two approaches.

