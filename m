Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1887 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbbAWSWY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 13:22:24 -0500
Date: Fri, 23 Jan 2015 13:21:57 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
To: <dsterba@suse.cz>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, Miao Xie <miaoxie@huawei.com>,
        <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Message-ID: <1422037317.28436.3@mail.thefacebook.com>
In-Reply-To: <20150123173909.GS13289@twin.jikos.cz>
References: <54BEF99D.7090104@cn.fujitsu.com>
	<1421802329.27917.8@mail.thefacebook.com>
	<54BEFC56.3000403@cn.fujitsu.com>
	<1421802656.27917.9@mail.thefacebook.com> <54BF189C.4070201@huawei.com>
	<54BF19DD.8060600@cn.fujitsu.com> <54BF1C5B.509@huawei.com>
	<54BF22BE.3080606@cn.fujitsu.com> <54BF4F62.3010805@huawei.com>
	<54BF59AA.9070408@cn.fujitsu.com> <20150123173909.GS13289@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Jan 23, 2015 at 12:39 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jan 21, 2015 at 03:47:54PM +0800, Qu Wenruo wrote:
>>  To David:
>>  I'm a little curious about why inode_cache needs to be delayed to 
>> next
>>  transaction.
>>  In btrfs_remount() we have s_umount mutex, and we synced the whole
>>  filesystem already,
>>  so there should be no running transaction and we can just set any 
>> mount
>>  option into fs_info.
> 
> See our discussion under the noinode_cache option:
> 
> https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%2540vger.kernel.org/msg30075.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=sv%2BL93W9i7vNsbS3ozpylY3o%2F3wpA4TZTQTtFh3mUXg%3D%0A&s=2d678af317413a7452f047aa9ed07bc7e5424d4bae831ac15fae5f23a2acd080
> https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%2540vger.kernel.org/msg30414.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=sv%2BL93W9i7vNsbS3ozpylY3o%2F3wpA4TZTQTtFh3mUXg%3D%0A&s=2fab711b3d70ab27c008694249bc62596f37e41af84dfc21077629930b4fe854
> 
>>  What do you think about reverting the whole patchset and rework the
>>  sysfs interface?
> 
> IMO reverting should be the last option, we have a minimal fix to the
> sync deadlock and you've proposed the per-trasaction mount options to
> replace the pending inode_change.

I agree, I'd rather build on top of what we have than use reverts at 
this point.

-chris



