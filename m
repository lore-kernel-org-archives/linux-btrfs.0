Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48531 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750954AbdFABEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 21:04:41 -0400
Subject: Re: [PATCH v4 05/20] btrfs-progs: Introduce wrapper to recover raid56
 data
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <lakshmipathi.g@gmail.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <20170525062205.11660-6-quwenruo@cn.fujitsu.com>
 <20170531135215.GE14523@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6eeff705-4b11-4169-9b58-5d2e2a0cb35b@cn.fujitsu.com>
Date: Thu, 1 Jun 2017 09:04:37 +0800
MIME-Version: 1.0
In-Reply-To: <20170531135215.GE14523@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/31/2017 09:52 PM, David Sterba wrote:
> On Thu, May 25, 2017 at 02:21:50PM +0800, Qu Wenruo wrote:
>> Introduce a wrapper to recover raid56 data.
>>
>> The logical is the same with kernel one, but with different interfaces,
>> since kernel ones cares the performance while in btrfs we don't care
>> that much.
> 
> Can you please rephrase this paragraph? I'll commit the patch as-is for
> now but want replace the changelog with an improved one.
> 
> 

I'm not sure which direction I should change the paragraph to.

To explain more about the wrapper or remove unrelated difference between 
kernel and btrfs-progs part?

Or why we need the wrapper?

Thanks,
Qu


