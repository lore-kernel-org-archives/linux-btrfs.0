Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:29607 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeDPHxc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 03:53:32 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A6FF0AC00DC
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 16:53:27 +0900 (JST)
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: <dsterba@suse.cz>, Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <20180412131318.GI21272@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <e697b170-fdc7-9f59-d224-095a39c4abef@jp.fujitsu.com>
Date: Mon, 16 Apr 2018 16:53:10 +0900
MIME-Version: 1.0
In-Reply-To: <20180412131318.GI21272@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/04/12 22:13, David Sterba wrote:
> On Tue, Apr 03, 2018 at 03:30:34PM +0800, Qu Wenruo wrote:
>> I didn't see this patch merged in your misc-next branch but only the
>> remaining patches.
>>
>> However without this patch, btrfs qgroup reserved space will get
>> obviously increased as prealloc metadata reserved space is never freed
>> until inode reserved space is freed.
>>
>> This would cause a lot of qgroup related test cases to fail.
>>
>> Would you please merge this patch with all qgroup patchset?
> 
> For the record: patch 9 and 10 are now in misc next and will go to 4.17.
> I need to let them through the for-next and other testing, so it will be
> some of the post rc1 pull requests.

I still saw qgroup related xfstests (btrfs/022 etc.) fails in current misc-next branch
which includes 9th and 10th patches.

I noticed 5th patch in the tree (already in v4.17-rc1) is older version and this
seems the reason that the tests still fails.

