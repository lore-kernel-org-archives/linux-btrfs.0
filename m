Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34619 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbcFBBHQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 21:07:16 -0400
Subject: Re: [PATCH v7 0/8] Inband dedupe for btrfs-progs
To: Mark Fasheh <mfasheh@suse.de>
References: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601213210.GK7633@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        <chris@suse.de>, Josef Bacik <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <78b48db4-c68c-8849-56d4-f7e1c518dd59@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 09:07:13 +0800
MIME-Version: 1.0
In-Reply-To: <20160601213210.GK7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/02/2016 05:32 AM, Mark Fasheh wrote:
> On Fri, Apr 01, 2016 at 02:37:42PM +0800, Qu Wenruo wrote:
>> No much change from previous version.
>> 1) Rebased to latest devel branch
>>
>> 2) Update ctree.h to follow kernel structure change
>>
>> 3) Update print-tree to follow kernel structure change
>>
>> Qu Wenruo (7):
>>   btrfs-progs: Basic framework for dedupe command group
>>   btrfs-progs: dedupe: Add enable command for dedupe command group
>>   btrfs-progs: dedupe: Add disable support for inband dedupelication
>>   btrfs-progs: dedupe: Add status subcommand
>>   btrfs-progs: Add dedupe feature for mkfs and convert
>>   btrfs-progs: Add show-super support for new DEDUPE flag
>>   btrfs-progs: debug-tree: Add dedupe tree support
>>
>> Wang Xiaoguang (1):
>>   btrfs-progs: property: add a dedupe property
>>
>>  Documentation/Makefile.in             |   1 +
>>  Documentation/btrfs-dedupe.asciidoc   | 150 ++++++++++++++++
>>  Documentation/btrfs-property.asciidoc |   2 +
>>  Documentation/btrfs.asciidoc          |   4 +
>>  Documentation/mkfs.btrfs.asciidoc     |   9 +
>>  Makefile.in                           |   3 +-
>>  btrfs-completion                      |   6 +-
>>  btrfs-convert.c                       |  19 +-
>>  btrfs.c                               |   1 +
>>  cmds-dedupe.c                         | 329 ++++++++++++++++++++++++++++++++++
>
> Can we please have seperate and obvious namespaces for in-band dedupe and
> out-of-band dedupe commands? I realize that there is no oob-dedupe
> funcationality in btrfs-progs today but I would like to avoid confusing
> users in the case that this code hits btrfs-progs.
>
> Specifically by this, I mean I'd like to see anything except 'dedupe' as the
> btrfs command, so a user who sees 'btrfs dedupe ....' is not confusing the
> two forms we have.
>
> I don't personally care what other name is used and of course it could have
> 'dedupe' in the name just not solely 'dedupe'. As a poor example, we could
> call it 'btrfs inband-dedupe ...'.

'btrfs inband-dedupe' sounds good to me.

Although I'd like to get more feedback for end users.

Thanks,
Qu
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


