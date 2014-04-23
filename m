Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19230 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755688AbaDWBVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 21:21:04 -0400
Message-ID: <535715BA.4010509@cn.fujitsu.com>
Date: Wed, 23 Apr 2014 09:22:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] btrfs-progs: Fix the return value when executing
 'btrfs pro get' on a uncompress file.
References: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com> <20140422123732.GA2027@twin.jikos.cz>
In-Reply-To: <20140422123732.GA2027@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2 4/4] btrfs-progs: Fix the return value when 
executing 'btrfs pro get' on a uncompress file.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月22日 20:37
> On Tue, Apr 15, 2014 at 05:22:24PM +0800, Qu Wenruo wrote:
>> When executing 'btrfs pro get' on a file which is not compressed, return
>> value will always be 50 since prop_compress() return -ENOATTR.
>>
>> But the codes have already check the errno to avoid unnecessary error
>> message, so the return value should also set to 0.
>>
>> Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
> JFYI, I've edited the subject and changelog, let's use the 'prop'
> abbreviation for properties.
Thanks for that.
My poor English seems always to be a problem.  :(

Qu
