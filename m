Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3A2Gw4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:52:56 -0500
Message-ID: <51077341.7060209@oracle.com>
Date: Tue, 29 Jan 2013 14:59:13 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH 05/10] Btrfs-progs: add function btrfs_get_subvol to get
 root_info of a subvol
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1359350559-25671-1-git-send-email-anand.jain@oracle.com> <1359350559-25671-6-git-send-email-anand.jain@oracle.com> <5107531E.8060708@gmail.com> <20130128180429.GB16594@twin.jikos.cz>
In-Reply-To: <20130128180429.GB16594@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  here the code is correct, this base does not have

   [PATCH] Btrfs-progs: filter the deleted subvolumes when listing snapshots

  which introduced -ENOENT as a return for the resolve_root.

  however since we should have that. I have integrated, and
  made corresponding changes in the btrfs_get_subvol. Kindly
  find V4.

Thanks, Anand


On 01/29/2013 02:04 AM, David Sterba wrote:
> On Mon, Jan 28, 2013 at 08:42:06PM -0800, Wang Shilong wrote:
>>> +	rbn = rb_first(&rl.root);
>>> +	while(rbn) {
>>> +		ri = rb_entry(rbn, struct root_info, rb_node);
>>> +		resolve_root(&rl, ri, root_id);
>>
>>    Here subvolume/snapshot deletion may happen,add a check here...
>>    if resolve_root return -ENOENT..it means deletion happens...
>>
>>    ret = reslove_root(&rl, ri, root_id);
>>    if (ret)
>>        goto again;
>>
> [...]
>>
>>   again???
>>> +		rbn = rb_next(rbn);
>>> +	}
>
> Then it looks like a for (...) { } pattern with 'continue' instead of
> 'goto'.
>
> david
