Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37352 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbdERJVU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 05:21:20 -0400
Subject: Re: [RFC PATCH 0/2] Introduce blkdev_issue_flush_no_wait()
To: Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <1494943642.2935.1.camel@sandisk.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6cc30419-c39c-de9f-0d0e-6c044ed75182@oracle.com>
Date: Thu, 18 May 2017 17:27:06 +0800
MIME-Version: 1.0
In-Reply-To: <1494943642.2935.1.camel@sandisk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2017 10:07 PM, Bart Van Assche wrote:
> On Tue, 2017-05-16 at 17:39 +0800, Anand Jain wrote:
>> BTRFS wanted a block device flush function which does not wait for
>> its completion, so that the flush for the next device can be called
>> in the same thread.
>>
>> Here is a RFC patch to provide the function
>> 'blkdev_issue_flush_no_wait()', which is based on the current device
>> flush function 'blkdev_issue_flush()', however it uses submit_bio()
>> instead of submit_bio_wait().
>>
>> This patch is for review comments, will send out a final patch based
>> on the comments received.
>
> Hello Anand,
>
> Since the block layer can reorder requests, I think using
> blkdev_issue_flush_no_wait() will only yield the intended result if
> the caller waits until the requests that have to be flushed have completed.
> Is that how you intend to use this function?

  Yes. The patch 2/2 did that. Sorry for no explanation though.

Thanks, Anand


> Thanks,
>
> Bart.N�����r��y���b�X��ǧv�^�)޺{.n�+����{�n�߲)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
>
