Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36997 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753482AbcIOS6g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 14:58:36 -0400
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
To: <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fb.com>
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
 <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
 <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
 <20160914181904.GB32358@localhost.localdomain>
 <20160915190108.GA23660@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <cc03eaca-a75e-b80c-9440-c2f07306bfee@fb.com>
Date: Thu, 15 Sep 2016 14:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <20160915190108.GA23660@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/15/2016 03:01 PM, Liu Bo wrote:
> On Wed, Sep 14, 2016 at 11:19:04AM -0700, Liu Bo wrote:
>> On Wed, Sep 14, 2016 at 01:31:31PM -0400, Josef Bacik wrote:
>>> On 09/14/2016 01:29 PM, Chris Mason wrote:
>>>>
>>>>
>>>> On 09/14/2016 01:13 PM, Josef Bacik wrote:
>>>>> On 09/14/2016 12:27 PM, Liu Bo wrote:
>>>>>> While updating btree, we try to push items between sibling
>>>>>> nodes/leaves in order to keep height as low as possible.
>>>>>> But we don't memset the original places with zero when
>>>>>> pushing items so that we could end up leaving stale content
>>>>>> in nodes/leaves.  One may read the above stale content by
>>>>>> increasing btree blocks' @nritems.
>>>>>>
>>>>>
>>>>> Ok this sounds really bad.  Is this as bad as I think it sounds?  We
>>>>> should probably fix this like right now right?
>>>>
>>>> He's bumping @nritems with a fuzzer I think?  As in this happens when someone
>>>> forces it (or via some other bug) but not in normal operations.
>>>>
>>>
>>> Oh ok if this happens with a fuzzer than this is fine, but I'd rather do
>>> -EIO so we know this is something bad with the fs.
>>
>> -EIO may be more appropriate to be given while reading btree blocks and
>> checking their validation?
>
> Looks like EIO doesn't fit into this case, either, do we have any errno
> representing 'corrupted filesystem'?

That's EIO.  Sometimes the EIO is big enough we have to abort, but 
really the abort is just adding bonus.

-chris

