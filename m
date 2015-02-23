Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8734 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbbBWTkB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 14:40:01 -0500
Date: Mon, 23 Feb 2015 14:39:54 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: Suddenly cannot change metadata profile any longer (BISECTED)
To: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1424720394.23448.1@mail.thefacebook.com>
In-Reply-To: <pan.2015.02.22.18.01.07@googlemail.com>
References: <pan.2015.02.15.21.01.07@googlemail.com>
	<pan.2015.02.16.15.18.40@googlemail.com>
	<pan.2015.02.22.18.01.07@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Sun, Feb 22, 2015 at 1:01 PM, Holger Hoffstätte 
<holger.hoffstaette@googlemail.com> wrote:
> On Mon, 16 Feb 2015 15:18:40 +0000, Holger Hoffstätte wrote:
> 
>>>  What works is the very first balance after the mkfs - it 
>>> successfully
>>>  changes from the initial default dup to single, but subsequent 
>>> balances
>>>  don't work. They also don't really fail.
>> 
>>  Bisection found that commit 
>> 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e [1]
>>  in the integration tree is the cause:
>> 
>>    btrfs: delete chunk allocation attemp when setting block group ro
>> 
>>  Reverting/omitting this patch lets me rebalance/convert at will.
> 
> Just for the list archives: Chris mailed me privately that they could
> reproduce the problem and will provide a fix post-3.20-rc1
> (since that commit already went in with the merge window).

Apparently reply-to-all is harder than it looks.  Thanks for forwarding 
this along.

-chris



