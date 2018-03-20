Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeCTJbS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 05:31:18 -0400
Subject: Re: [PATCH 4.14 024/110] btrfs: use proper endianness accessors for
 super_copy
To: dsterba@suse.cz, Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20180307191039.748351103@linuxfoundation.org>
 <20180307191042.810088712@linuxfoundation.org>
 <1521139304@msgid.manchmal.in-ulm.de> <20180316123049.GC25079@kroah.com>
 <1521305582@msgid.manchmal.in-ulm.de> <20180319193221.GP6955@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b14fedbb-55d1-815c-eaa5-c69b5d785615@oracle.com>
Date: Tue, 20 Mar 2018 17:32:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180319193221.GP6955@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/20/2018 03:32 AM, David Sterba wrote:
> On Sat, Mar 17, 2018 at 06:27:15PM +0100, Christoph Biedl wrote:
>> Greg Kroah-Hartman wrote...
>>
>>> On Thu, Mar 15, 2018 at 07:55:42PM +0100, Christoph Biedl wrote:
>>
>>>>> commit 3c181c12c431fe33b669410d663beb9cceefcd1b upstream.
>>
>>>> On big-endian systems, this change intruduces severe corruption,
>>>> resulting in complete loss of the data on the used block device.
>>
>>> That sucks.  Can you test Linus's tree to verify the problem is there?
>>> I'll gladly revert this if Linus's tree also gets the revert, I don't
>>> want you to hit this when you upgrade to a newer kernel.
>>
>> Confirmed: The problem is, err ... was in Linus' tree as well. The
>> rather recent commit 8f5fd927c3a7 reverted the change, after that
>> everything is as expected again.
> 
> Thanks for checking.
> 
>> Looking at the original commit, I don't have a clue why things go wrong
>> so horribly
> 
> It's a half endianness conversion. The plain in-memory structures are in
> LE and has to be accessed via the helpers, super block copy and the
> root item.  The commit adds only one half of the conversion, that
> naturally does not exhibit on LE, because the macros are no-op.
> 
> Originally, the items were stored from the on-disk type to on-disk type,
> regardless of the CPU:
> 
>    super->chunk_root = root_item->bytenr;
> 
> The patch should have added conversion of both values, like
> 
>    btrfs_set_super_chunk_root(super, btrfs_root_bytenr(root_item));
> 
> and not
> 
>    btrfs_set_super_chunk_root(super, root_item->bytenr);
> 
> It's not very obvious from the context though, typically there's one
> structure that needs the accessors and is set from a value that's in CPU
> byteorder. I think that the exception to this pattern confused all
> involved developers.
> 
> The root_item members are annotated as __le64 that should be caught by
> sparse/smatch checker in the buggy case, but we don't run the checkers
> every the time.

  Ah! the RC is at the other side of the equation.
  Makes sense to me. Thanks.

>> - otherwise don't be afraid of my data. I took this as a
>> chance to verify my data recovery procedure, with success.
> 
> Should that not be the case, the damaged items in superblock can be
> byteswapped back. That's 6 x u64 at most, I have a tool for that now.
> 
> Thanks again for the report and sorry for the trouble.

  It's entirely my mistake. My apologies for the inconvenience.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
