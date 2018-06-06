Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:49162 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeFFEGO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 00:06:14 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
 <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
 <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
 <ac13c732-29a3-89c7-0fe2-f3222e7cb6ee@gmx.com> <87lgc2mrud.fsf@shaw.ca>
 <5eac8b95-b6cd-87ef-2f16-573be326ef37@gmx.com>
From: Steve Leung <sjleung@shaw.ca>
Message-ID: <13819df6-07eb-23db-1202-310f1b84b7f8@shaw.ca>
Date: Tue, 5 Jun 2018 22:06:11 -0600
MIME-Version: 1.0
In-Reply-To: <5eac8b95-b6cd-87ef-2f16-573be326ef37@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/2018 11:30 PM, Qu Wenruo wrote:
> 
> 
> On 2018年05月29日 22:58, Steve Leung wrote:
>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>
>>> On 2018年05月28日 11:47, Steve Leung wrote:
>>>> On 05/26/2018 06:57 PM, Qu Wenruo wrote:
>>>>>
>>>>>
> [snip]
>>> Still nope.
>>> What about encrypt it and upload it to some public storage provider like
>>> google drive/dropbox?
>>
>> Ok, uploaded to Google Drive.  You'll need to request access to it.
>>
>>    https://drive.google.com/file/d/16NM1NVoMVgkJ_JiePi8VfAzit5_Onz2H/view?usp=sharing
>>
>> sha256sum for the file should be:
>>
>>    ea0abc21fcbc3a71c68b7307d57b26763ac711bd3437a60e32db3144facfeb3f
> Sorry for the slow reply.
> 
> After all the testing, the result is a little surprising.
> 
> It's indeed *CORRUPTED*! And tree-checker code exposed it.
> 
> It's just btrfs-progs and kernel print-tree code doesn't use correct
> ram_bytes to output, thus pretty tricky to expose.
> 
> The problem is the ram_bytes of that inlined extent, it's indeed larger
> than it should, just by one byte.
> 
> I'm not completely sure how it's happened, but according to the
> timestamp it's 4 years ago and I think some kernel off-by-one error
> happens and fixed.
> 
> And current kernel can handle it pretty well without reading out the
> last byte.
> However it's still a corruption.
> 
> Although it's not a big problem, and can be fixed easily.
> I'll submit a btrfs-progs patch to allow btrfs-check to fix in this week.

Ok great to hear!  I'll give it a test whenver you have it.

Steve
