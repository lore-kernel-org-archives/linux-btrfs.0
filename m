Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49682 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdADL2K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 06:28:10 -0500
Subject: Re: [PATCH 1/2] btrfs: btrfs_defrag_root() doesn't support any option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20161221074208.32597-1-anand.jain@oracle.com>
 <20170103162124.GQ12081@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f43b85dc-409c-e82a-e699-35cd42a9348a@oracle.com>
Date: Wed, 4 Jan 2017 19:30:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170103162124.GQ12081@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/04/17 00:21, David Sterba wrote:
> On Wed, Dec 21, 2016 at 03:42:07PM +0800, Anand Jain wrote:
>> Both BTRFS_IOC_DEFRAG and BTRFS_IOC_DEFRAG_RANGE call the same
>> function- btrfs_ioctl_defrag(), however BTRFS_IOC_DEFRAG does
>> not support any argument, so check that and return not supported
>> if provided. This has valid impact at the user end, in the cli below
>>   btrfs filesystem defrag -clzo /btrfs
>> the -c option (or similarly other) is only applicable to the file
>> defrag, which is either provided in the argument or when used along
>> with the -r option, however as of now the above cli does not report
>> any error. This patch will fix it.
>
> I think it would be better to do the sanitization on the userspace side.
 >
> In this case combination of a compression option and bare directory
> would not lead to the expected result.

  Hmm.. I am confused on the expected result here, what should it be ?
  My thinking, compression option on the directory is not supported.
  That's because the kernel calls btrfs_defrag_root() for dir as arg,
  which does not accept any option.

  In the same context if either -r option is used (then it picks up
  individual files as arg) or if a file is used as arg, then kernel
  calls btrfs_defrag_files() which then the options makes sense.

> IMO it's deciding between
>
>   "pass any arguments to kernel" - here returning EOPNOTSUPP would be
>   quite unclear what went wrong
>
> vs.
>
>   "validate as much arguments as we can before passing to kernel" - and
>   we'll know early that the combination is not valid, also that we want
>   to deprecate it etc.

  btrfs-progs is one of the tool. If API is tested with a test program
  it will still can be shown as failing.

  The kernel problem statement is:
    - ioctl("/dir", BTRFS_IOC_DEFRAG, options)
    - ioctl("/dir", BTRFS_IOC_DEFRAG_RANGE, options)
  the above ioctl usage provides false impression that options have
  worked, but the kernel does not use the options at all.

  Its a different story if btrfs_defrag_root() would support options
  in the long term ?

> I vote for #2 as we have enough information to give an informative error
> message.

Thanks, Anand

