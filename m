Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:54884 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753828AbdJaRAI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:00:08 -0400
Received: by mail-io0-f175.google.com with SMTP id e89so182235ioi.11
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 10:00:07 -0700 (PDT)
Subject: Re: btrfs-subv-backup v0.1b
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        Btrfs ML <linux-btrfs@vger.kernel.org>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
 <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de>
 <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com>
 <551550025.428652.1509468869372.JavaMail.zimbra@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56f78e50-bfc1-66cc-141e-41cfa446f855@gmail.com>
Date: Tue, 31 Oct 2017 13:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <551550025.428652.1509468869372.JavaMail.zimbra@helmholtz-muenchen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 12:54, Lentes, Bernd wrote:
> ----- On Oct 31, 2017, at 2:59 PM, Austin S. Hemmelgarn ahferroin7@gmail.com wrote:
> 
>>> Hi Austin,
>>>
>>> thanks for your effort. What are the minimum prerequesties for kernel and
>>> btrfsprogs for that script ?
>>> Do you think it will run on my old SLES 11 SP4 ?
>> Dependency-wise, it needs:
>>
>> kernel: Should work with any kernel version that has BTRFS support,
>> untested on kernels before 4.10, but I'm fairly confident that it should
>> work on just about anything.  If there's going to be a failure due to
>> kernel version, it should happen when saving the subvolume information,
>> so you should be safe checking this (especially since the script doesn't
>> write anything when saving the info until the very end, and doesn't use
>> any write capable ioctls when fetching the info).
>>
>> btrfs-progs: Only uses the subvolume list, create, and delete commands,
>> and the only one which may have changed significantly in the past few
>> years is the list command.  I've only tested it with btrfs-progs 4.10.2
>> and newer, but I expect it should work with any of them at least since
>> the change to matching kernel versions.  You can quickly check this by
>> making sure the output of `btrfs subvolume list` looks like this:
>>
>>      ID 257 gen 769304 top level 5 path root
>>
>> What matters there is the number of words between each number, as the
>> parsing code is pretty naive.
>>
>> util-linux: We use blkid to get the filesystem label and UUID so that
>> it's more evident in the file what filesystem it's for (in case you
>> decide to stroe them separately), but as far as I know the relevant
>> command-line options haven't changed in at least half a decade, so any
>> reasonably recent version should work fine (tested with util-linux
>> 2.31).  As the script is currently, this will cause it to throw an
>> exception if it doesn't work, but that will happen before it does almost
>> anything else, so it should still fail safe.
>>
>> Python: btrfs-subv-backup requires Python 3.  I've only tested it on 3.4
>> and 3.6, but I'm pretty sure it should work on most versions back to at
>> least 3.2.  Of the dependencies, this is the one I'd expect to be the
>> most likely possible issue on older distros, but you likely have a new
>> enough version already given the kernel build date shown below.  If this
>> doesn't work, you will get syntax errors (specifically around the error
>> handlers).
>>
> 
> damned, i have 2.6.9 and the most recent i fnd in repositories for SLES 11 SP4 is 2.7.6
Assuming you're careful about how you install it (that is, put it in a 
custom prefix that isn't in $PATH), you could always build a local 
version of Python.  Once you've got that, it's pretty trivial to change 
the #! line at the beginning of the script to point to the appropriate 
location.

For what it's worth, it shouldn't be _too_ hard to get the script 
working with Python 2.7.  The only big syntax difference that's liable 
to be an issue is the except clauses.  I'll take a look at this and see 
if I can't get it working for both 3.X and 2.7.

