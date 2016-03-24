Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24970 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcCXL1c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:27:32 -0400
Subject: Re: [PATCH] fstest: btrfs: remove _need_to_be_root fix btrfs/118
To: fdmanana@gmail.com
References: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
 <CAL3q7H5APJE6bWpi=kYMuC4sMRvYuEh5ouVTLxfQCRQO4EThew@mail.gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56F3CF1B.2040006@oracle.com>
Date: Thu, 24 Mar 2016 19:27:23 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5APJE6bWpi=kYMuC4sMRvYuEh5ouVTLxfQCRQO4EThew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/24/2016 07:08 PM, Filipe Manana wrote:
> On Thu, Mar 24, 2016 at 10:13 AM, Anand Jain <anand.jain@oracle.com> wrote:
>> commit 56ff01f471c9b72de0a447b37cdb1051adcede6a
>>      xfstests: remove _need_to_be_root
>>
>> Removed _need_to_be_root(), and so btrfs/118 needs an update
>
> https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=3a9242688d64c669ca764ee2c5599abfc885c131
>
> It's always a good idea to check if one is using the latest git branch
> and the mailing list... :)

Err. Yep. Sorry for the noise.
