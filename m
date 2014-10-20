Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20351 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751840AbaJTQJi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 12:09:38 -0400
Date: Mon, 20 Oct 2014 12:09:22 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs for stable (mostly 3.17)
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, <stable@vger.kernel.org>
Message-ID: <1413821362.12598.0@mail.thefacebook.com>
In-Reply-To: <20141019231315.GA9846@kroah.com>
References: <20141019231315.GA9846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Sun, Oct 19, 2014 at 7:13 PM, Greg KH <gregkh@linuxfoundation.org> 
wrote:
> On Sun, Oct 19, 2014 at 09:55:11PM +0200, Greg KH wrote:
>>  On Sun, Oct 19, 2014 at 06:01:16AM -0400, Chris Mason wrote:
>>  > Hi everyone,
>>  >
>>  > I've pulled out some of the btrfs commits from the merge window 
>> that
>>  > we'd like to see in stable.  The full list of sha's from Linus is 
>> below,
>>  > you can see 4 of them are only needed on 3.17
>>  >
>>  > 2fad4e83e12591eb3bd213875b9edc2d18e93383
>>  > 0b4699dcb65c2cff793210b07f40b98c2d423a43 # v3.17
>>  > 12b894cb288d57292b01cf158177b6d5c89a6272
>>  > 78a017a2c92df9b571db0a55a016280f9019c65e
>>  > 4d1a40c66bed0b3fa43b9da5fbd5cbe332e4eccf
>>  > e6c4efd87ab04e5ead363f24e6ac35ed3506d401 # v3.17
>>  > f6acfd50110b335c7af636cf1fc8e55319cae5fc
>>  > 1d52c78afbbf80b58299e076a159617d6b42fe3c
>>  > 75bfb9aff45e44625260f52a5fd581b92ace3e62
>>  > bbe9051441effce51c9a533d2c56440df64db2d7
>>  > 32be3a1ac6d09576c57063c6c350ca36eaebdbd3 # v3.17
>>  > 42383020beb1cfb05f5d330cc311931bc4917a97
>>  > d37973082b453ba6b89ec07eb7b84305895d35e1 # v3.17
>> 
>>  I'm confused, the others not marked with a "# v3.17" need to go on 
>> older
>>  kernels as well?
> 
> I've picked up the ones that apply and build for the older stable
> kernels I maintain now, thanks for the list.

Sorry I wasn't clear.  The other unmarked ones should go back to the 
older kernels as well.

-chris



