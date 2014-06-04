Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55430 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680AbaFDBqt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 21:46:49 -0400
Message-ID: <538E79A8.3070403@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 09:43:04 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH v2 3/4] Btrfs-progs: fsck: deal with corrupted csum root
References: <1401357597-9494-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1401357597-9494-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140602172736.GE22324@twin.jikos.cz> <538D403D.603@cn.fujitsu.com> <20140603162124.GQ22324@twin.jikos.cz>
In-Reply-To: <20140603162124.GQ22324@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/2014 12:21 AM, David Sterba wrote:
> On Tue, Jun 03, 2014 at 11:25:49AM +0800, Wang Shilong wrote:
>> On 06/03/2014 01:27 AM, David Sterba wrote:
>>> On Thu, May 29, 2014 at 05:59:57PM +0800, Wang Shilong wrote:
>>>> If checksum root is corrupted, fsck will get segmentation. This
>>>> is because if we fail to load checksum root, root's node is NULL which
>>>> cause NULL pointer deferences later.
>>>>
>>>> To fix this problem, we just did something like extent tree rebuilding.
>>>> Allocate a new one and clear uptodate flag. We will do sanity check
>>>> before fsck going on.
>>> I'm a bit worried about recommending --init-csum-root, though in this
>>> case there's not much else left to do. A filesystem with initialized
>>> csum tree will mount, but reading non-inline data will produce 'csum
>>> missing' errors.
>> Agree.
> Are you ok with removing the "rerun with --init-csum-tree option" part
> of the message?
That's not good, i agree with your point here.
>
>>>> --- a/cmds-check.c
>>>> +++ b/cmds-check.c
>>>> @@ -6963,6 +6963,11 @@ int cmd_check(int argc, char **argv)
>>>>   		ret = -EIO;
>>>>   		goto close_out;
>>>>   	}
>>>> +	if (!extent_buffer_uptodate(info->csum_root->node)) {
>>>> +		fprintf(stderr, "Checksum root corrupted, rerun with --init-csum-tree option\n");
>>>> +		ret = -EIO;
>>>> +		goto close_out;
>>> So this should prevent segfaults due to missing csum tree, fine. The
>>> error message can copy what the broken extent tree reports a few lines
>>> above.
>>>
>>> And now that I'm looking at other extent_buffer_uptodate(tree) checks in
>>> the function, for clarity, each root check should be done separately and
>>> followed by a message that says which tree is broken.
>> Normally, extent_buffer_update(tree) is called after reading.
>> We need this in fsck is because we need reinit extent tree and csum tree.
>>
>> check it again is to make sure root node has been setup properly and
>> fsck can go further..
> Yeah, I see how it works now, thanks.
>
> I've reorganized the patches in integration so the ones for fsck are
> grouped together. Fsck is scary and needs more reviews obviously, so the
> patches will be pushed towards release branches based on that. Reviews
> or tests so to say. I appreciate your work in that area and hope you
> understand the slow progress with your patches.
That's ok for me, thanks for your review and comments^_^

> .
>

