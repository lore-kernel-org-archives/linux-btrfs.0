Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:44373 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeHOOON (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 10:14:13 -0400
Received: by mail-qk0-f196.google.com with SMTP id v17-v6so462954qkb.11
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 04:22:26 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Jeff Mahoney <jeffm@suse.com>, Thomas Leister <thomas.leister@mailbox.org>,
        dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b121976e-fcbf-1349-9e1d-c14904604a17@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <52459297-25ec-f3d9-ba50-8eaccfc4ea4d@gmail.com>
Date: Wed, 15 Aug 2018 07:22:22 -0400
MIME-Version: 1.0
In-Reply-To: <b121976e-fcbf-1349-9e1d-c14904604a17@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-13 22:49, Jeff Mahoney wrote:
> On 7/31/18 9:49 AM, Thomas Leister wrote:
>> Dear David,
>> hello everyone,
>>
>> during a recent project of mine involving LXD and BTRFS I found out that
>> quotas on BTRFS subvolumes are enforced, but file system usage and
>> limits set via quotas are not reported correctly in LXC containers.
>>
>> I've found this discussion regarding my problem:
>> https://github.com/lxc/lxd/issues/2180
>>
>> There was already a proposal to introduce subvolume quota support some
>> time ago:
>> https://marc.info/?l=linux-btrfs&m=147576434114415&w=2
>>
>> @David as I've seen your response on that topic on the mailing list,
>> maybe you can tell me if there are any plans to support correct
>> subvolume quota reporting e.g. for "df -h" calls from within a
>> container? Maybe there's already something on your / SUSE's roadmap? :-)
>>
>> As more and more container environments spin up these days, there might
>> be a growing demand on that :-) Personally I'd really appreciate if I
>> could read the current file system usage and limit from within a
>> container using BTRFS as storage backend.
> 
> In addition to Qu's deeper dive into the qgroup internals, the bigger
> issue is that statfs(), which df uses, only allows the kernel to report
> two numbers to describe space usage: total blocks and free blocks[1].
> 
> Currently, the only space tracking we have at a subvolume level is
> qgroups.  There are other trees than "file" (i.e. subvolume) trees in
> btrfs and those aren't accounted using qgroups.
Last I knew, ext4 and XFS didn't count metadata (other than xattrs) 
against quotas, so outside of accounting inlined files properly (I'm not 
sure if qgroups do so or not), we're about equivalent to them in terms 
of what we're counting.
> 
> So what should these numbers contain to describe to the user what their
> space usage looks like?  We can have subvolume qgroup limits, nested
> qgroup limits, disk capacity limits.  Df on btrfs is already confusing
> enough with the data/metadata allocation split combined with potentially
> different allocation policies for each.
This is _easy_ though.  You report whatever the lowest current limit is. 
  99% of the time if something or someone is calling `df`, they want to 
know how much space on that volume is currently available for usage. 
Just reporting whichever of the limits they're going to hit first 
handles that case perfectly, and more importantly, is completely 
unambiguous.
> 
> That's the biggest hurdle to reporting per-subvolume information via df.
>   It's a feature request that's been in my TODO inbox for a while.  I
> started in on it again this year and came to the conclusion that wiring
> qgroups into df would be easy[2] - but would ultimately raise more
> questions than it solved for the user.  That's pretty much what I'm
> seeing in this thread.
> 
> So, what I have mostly working is adding support for 'btrfs qgroup show'
> to output in JSON format so that tools can be easily written to use the
> numbers available to provide exactly what information the user wants
> (given the limit of what's available.)
> 
> -Jeff
> 
> [1] There's f_bavail too, but that's not really relevant and runs into
> the same issue as above in any case.
> [2] Well, wiring it into statfs would be easy.  Publishing vfsmounts for
> every subvolume so df actually calls it on unqualified 'df' executions
> is rather a bit more involved.
But probably worth it, because we could then expose in the mount options 
for each subvolume whether or not it's in a qgroup (and possibly which 
one if it is), which would help alleviate a decent percentage of the 
confusion.  Right now, it's a pain in the arse to figure out if a given 
subvolume has a quota or not, because _none_ of the conventional methods 
of determining if quotas are in effect work at all.
