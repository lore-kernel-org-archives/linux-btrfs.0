Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41347 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755014AbeCVNhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:37:45 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Remove deprecated btrfs-zero-log
 standalone tool
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
 <77235266-888e-14d2-ac50-057b6f4d8390@gmx.com>
 <20180322133140.GY6955@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d29ba513-7a03-66ec-61d3-28ee07a80b83@suse.com>
Date: Thu, 22 Mar 2018 15:37:43 +0200
MIME-Version: 1.0
In-Reply-To: <20180322133140.GY6955@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.03.2018 15:31, David Sterba wrote:
> On Thu, Mar 22, 2018 at 09:29:46PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年03月22日 21:18, Nikolay Borisov wrote:
>>> Its function has been subsumed by "btrfs rescue zero-log". Remove its
>>> source file and adjust make/tests soruces accordingly.
>>
>> Despite of the lack of sob tag, it looks good.
>>
>>> ---
>>>  Makefile                              |  4 +-
>>>  btrfs-zero-log.c                      | 78 -----------------------------------
>>>  tests/misc-tests.sh                   |  1 -
>>>  tests/misc-tests/003-zero-log/test.sh |  6 +--
>>
>> What about updating .gitignore to remove btrfs-zero-log?
> 
> Not just that, here's the whole checklist:
> 
> https://github.com/kdave/btrfs-progs/issues/97

I saw the checklist but wasn't sure about the "document removal" bit.

> 
