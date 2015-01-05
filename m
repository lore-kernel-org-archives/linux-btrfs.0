Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12953 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753231AbbAEKCr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 05:02:47 -0500
Message-ID: <54AA6097.5000807@cn.fujitsu.com>
Date: Mon, 5 Jan 2015 17:59:51 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com> <548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com> <549017E8.7060107@cn.fujitsu.com> <54908D8A.8040101@pobox.com> <54916B39.5080409@cn.fujitsu.com> <549252FF.10400@pobox.com> <549960B9.20300@cn.fujitsu.com> <549E070E.8030509@pobox.com>
In-Reply-To: <549E070E.8030509@pobox.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 09:10 AM, Robert White wrote:
> On 12/23/2014 04:31 AM, Dongsheng Yang wrote:
>> On 12/18/2014 12:07 PM, Robert White wrote:
...
>> Thanx
>> Yang
>>> . xaE
>>>
>>
>>
>
> Fine. but you still haven't told me/us what you thing df (really 
> fsstat() ) should report in those cases.
>
> Go back to that email. Grab some of those cases. Then tell me what 
> your patch will report and why it makes more sense than what is 
> reported now.
>
> For code to be correct it _must_ be correct for the "special" cases. 
> You don't get to just ignore the special cases.
>
> So what are your specific answers to those cases?

Great to hear that we can stop the endless discussion of FS level VS 
device level.

Then we can come back to discuss the special cases you provided. I give 
you some answer
in another mail. And make a change in my patch to cover the case of 
un-finished
balance.

Thanx
> .
>

