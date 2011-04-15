From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: if we've already started a trans handle, use that
 one
Date: Fri, 15 Apr 2011 14:12:20 -0400
Message-ID: <4DA88A84.9080506@redhat.com>
References: <1302886575-2025-1-git-send-email-josef@redhat.com> <1302888971-sup-9684@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302888971-sup-9684@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2011 01:36 PM, Chris Mason wrote:
> Excerpts from Josef Bacik's message of 2011-04-15 12:56:15 -0400:
>> We currently track trans handles in current->journal_info, but we don't actually
>> use it.  This patch fixes it.  This will cover the case where we have multiple
>> people starting transactions down the call chain.  This keeps us from having to
>> allocate a new handle and all of that, we just increase the use count of the
>> current handle, save the old block_rsv, and return.  I tested this with xfstests
>> and it worked out fine.  Thanks,
>
> Just curious, which call stacks are currently nesting transactions?
>

The one that kept getting me in trouble was the run_delalloc_nocow which 
could possibly call cow_file_range.  I didn't notice any others, but I 
didn't really look all that hard either.  Thanks,

Josef
