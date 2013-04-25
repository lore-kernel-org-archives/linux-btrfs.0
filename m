Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab3DYL0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 07:26:14 -0400
Message-ID: <51791305.50500@cn.fujitsu.com>
Date: Thu, 25 Apr 2013 19:27:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 2/2] Btrfs: introduce noextiref mount option
References: <51669144.20107@cn.fujitsu.com> <516691F0.4080204@cn.fujitsu.com> <51683DDF.9010004@redhat.com> <20130415172050.GF18193@twin.jikos.cz>
In-Reply-To: <20130415172050.GF18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 15 Apr 2013 19:20:51 +0200, David Sterba wrote:
> On Fri, Apr 12, 2013 at 12:01:19PM -0500, Eric Sandeen wrote:
>> On 4/11/13 5:35 AM, Miao Xie wrote:
>>> Now, we set incompat flag EXTEND_IREF when we actually need insert a
>>> extend inode reference, not when making a fs. But some users may hope
>>> that the fs still can be mounted on the old kernel, and don't hope we
>>> insert any extend inode references. So we introduce noextiref mount
>>> option to close this function.
>>
>> I'd really rather not have yet another work-around mount option.
>>
>> Wouldn't it be better to say: if you don't want extended irefs, turn
>> that feature off on the filesystem itself, either at mkfs time or via
>> btrfstune after the fact.
> 
> I agree with this, and hope the inconsistency around extref is only
> temporary so the mount options is not required in the long term.
> 
> The code reverting extref set by default in mkfs is in integration
> branch.
> 
> The preferred solution is the -O option where we can put all the fs
> features in one go at mkfs time.

All right, let's add a option for mkfs, and throw away this patchset.

Thanks.
Miao
