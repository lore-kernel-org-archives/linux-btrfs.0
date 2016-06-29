Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35828 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcF2EHT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 00:07:19 -0400
Received: by mail-lf0-f44.google.com with SMTP id l188so24566222lfe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 21:07:18 -0700 (PDT)
Subject: Re: Bug in 'btrfs filesystem du' ?
To: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20160627132841.GA11661@invalid> <20160627133310.GB11661@invalid>
 <CAPmG0jbcojqdERe39Fnu20mg2e2VyxJOUi53Zy6kV_=B=q-zEA@mail.gmail.com>
 <20160628125639.GA6997@invalid>
 <CAPmG0jZCQ9WDqc3hHxp9GvZmEb=_TQ5JqUEcgfy2Vm_E42sscA@mail.gmail.com>
 <5772B1FA.5010004@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57734974.4050405@gmail.com>
Date: Wed, 29 Jun 2016 07:07:16 +0300
MIME-Version: 1.0
In-Reply-To: <5772B1FA.5010004@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

28.06.2016 20:20, Andrei Borzenkov пишет:
> 28.06.2016 19:55, Henk Slager пишет:
>> On Tue, Jun 28, 2016 at 2:56 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
>>> Hello,
>>>
>>> Am Montag, den 27. Juni schrieb Henk Slager:
>>>> On Mon, Jun 27, 2016 at 3:33 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
>>>>> Am Montag, den 27. Juni schrieb M G Berberich:
>>>>>> after a balance ‘btrfs filesystem du’ probably shows false data about
>>>>>> shared data.
>>>>>
>>>>> Oh, I forgot: I have btrfs-progs v4.5.2 and kernel 4.6.2.
>>>>
>>>> With  btrfs-progs v4.6.1 and kernel 4.7-rc5, the numbers are correct
>>>> about shared data.
>>>
>>> I tested with kernels 4.6.3 and 4.7-rc5 and with btrfs-progs 4.5.2 and
>>> 4.61.
>> Also with kernel 4.6.2-1-default and btrfs-progs v4.5.3+20160516
>> (current stock opensuse tumbleweed) I cannot reproduce the problem.
>>
> 
> I confirm the same behavior on openSUSE Tumbleweed with kernel 4.6.2-1.2
> and btrfsprogs 4.5.3-1.2 using provided script.
> 

I realized that it sounded ambiguous. I do see the reported bug on
openSUSE Tumbleweed using the same versions as you. After rebalance
shared data disappears completely in du output.

