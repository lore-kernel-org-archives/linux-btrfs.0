Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114AbbCCUU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 15:20:58 -0500
Date: Tue, 3 Mar 2015 12:20:57 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
Message-ID: <20150303202057.GU21790@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com> <54DDC62D.4070206@cn.fujitsu.com> <54EEB798.1070105@cn.fujitsu.com> <54F5988C.4020905@cn.fujitsu.com> <54F5BE84.7090202@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54F5BE84.7090202@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 09:00:36AM -0500, Josef Bacik wrote:
> On 03/03/2015 06:18 AM, Dongsheng Yang wrote:
>> On 02/26/2015 02:05 PM, Dongsheng Yang wrote:
>>> Wait a minute, this patch seems not working well in accounting quota
>>> number when
>>> deleting data shared by different subvolumes.
>>>
>>> I will investigate more about it and send a V2 out.
>> I have sent a fstest
>>   [PATCH] fstest: btrfs: add a test for quota number when deleting a
>> subvol.
>> for this problem I was trying to solve in this patch.
>>
>> Please consider reverting the two commits introduced the problem:
>>
>> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
>> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
>>
>
> We aren't reverting these two commits, what we had was worse before than it 
> is now.  We need to figure out why this is resulting in problems and fix 
> that rather than throwing out a whole bunch of work.  Thanks,

Agreed, reverting these would re-introduce far more problems than it would
solve.
	--Mark

--
Mark Fasheh
