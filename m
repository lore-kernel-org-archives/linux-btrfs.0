Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12328 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055AbaIPFUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 01:20:10 -0400
Message-ID: <5417C886.7020601@cn.fujitsu.com>
Date: Tue, 16 Sep 2014 13:20:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] btrfs-progs: Check superblock's checsum when read
 dev super
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com> <1404380198-25948-2-git-send-email-quwenruo@cn.fujitsu.com> <20140915113612.GC9715@twin.jikos.cz> <20140915114436.GD9715@twin.jikos.cz>
In-Reply-To: <20140915114436.GD9715@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2 1/4] btrfs-progs: Check superblock's checsum when 
read dev super
From: David Sterba <dsterba@suse.cz>
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
<linux-btrfs@vger.kernel.org>
Date: 2014年09月15日 19:44
> On Mon, Sep 15, 2014 at 01:36:12PM +0200, David Sterba wrote:
>> We've got a report of mismatched checksum and bisected to this patch.
> ...
>> But then I don't see the point of the patch, the code would just use a
>> bigger temprary buffer for no apparent reason, the outcom is the same.
> Scatch that, the patch seems in line with what kernel does and there
> must be another reason of the mentioned bug.
That's OK。

But I am somewhat interesting about the report of mismatched csum.
Would you like to share some of the details?

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

