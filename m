Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49797 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753801AbcINR35 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 13:29:57 -0400
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
To: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
Date: Wed, 14 Sep 2016 13:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/14/2016 01:13 PM, Josef Bacik wrote:
> On 09/14/2016 12:27 PM, Liu Bo wrote:
>> While updating btree, we try to push items between sibling
>> nodes/leaves in order to keep height as low as possible.
>> But we don't memset the original places with zero when
>> pushing items so that we could end up leaving stale content
>> in nodes/leaves.  One may read the above stale content by
>> increasing btree blocks' @nritems.
>>
>
> Ok this sounds really bad.  Is this as bad as I think it sounds?  We
> should probably fix this like right now right?

He's bumping @nritems with a fuzzer I think?  As in this happens when 
someone forces it (or via some other bug) but not in normal operations.

-chris
