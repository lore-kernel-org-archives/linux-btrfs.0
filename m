Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36068 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbcGUVZZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 17:25:25 -0400
Received: by mail-wm0-f53.google.com with SMTP id q128so35309304wma.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 14:25:24 -0700 (PDT)
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Chris Mason <clm@fb.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <35812568.Zn4Yz0rfXf@localhost.localdomain>
 <20160719110534.GA96833@clm-mbp.thefacebook.com>
 <5d481869-b442-121c-8741-d5ff11e48de4@gmail.com>
 <5f1dc52b-11cb-8977-3410-e71e0b2d0c00@fb.com>
 <2ce1eb99-2e9f-f9cb-7601-6e67301979cd@gmail.com>
 <7de268a1-c7d2-b819-d15c-c26416996c94@fb.com>
From: Gabriel C <nix.or.die@gmail.com>
Message-ID: <2cf60d0b-1d80-ae27-4d37-fa07681afb77@gmail.com>
Date: Thu, 21 Jul 2016 23:25:02 +0200
MIME-Version: 1.0
In-Reply-To: <7de268a1-c7d2-b819-d15c-c26416996c94@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.07.2016 14:56, Chris Mason wrote:
> On 07/20/2016 01:50 PM, Gabriel C wrote:
>>
>> After 24h of running the program and thundirbird all is still fine here.
>>
>> I let it run one more day.. But looks very good.
>>
> 
> Thanks for your time in helping to track this down.  It'll go into the 
> next merge window and be cc'd to stable.
> 

You are welcome :)

Test program was running without problems for 52h.. I think your fix is fine :)

Also feel free to add Tested-by: Gabriel Craciunescu <nix.or.die@gmail.com> to you commit.

Regrads,

Gabriel
