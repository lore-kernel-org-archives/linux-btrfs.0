Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35877 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755522AbcLSLJV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 06:09:21 -0500
Subject: Re: [PATCH] recursive defrag cleanup
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20161206043938.3249-1-anand.jain@oracle.com>
 <20161212171927.GY12522@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com>
Date: Mon, 19 Dec 2016 19:12:51 +0800
MIME-Version: 1.0
In-Reply-To: <20161212171927.GY12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/13/16 01:19, David Sterba wrote:
> On Tue, Dec 06, 2016 at 12:39:37PM +0800, Anand Jain wrote:
>> The command,
>>    btrfs fi defrag -v /btrfs
>>  does nothing, it won't defrag the files under /btrfs as user
>>  may expect. The command with recursive option
>>    btrfs fi defrag -vr /btrfs
>>  would defrag all the files under /btrfs including files in
>>  its sub directories.
>>
>>  While attempting to fix this. The patch below 1/1 provides
>>  a cleanup. And the actual fix is pending, as to my understanding
>>  of nfwt() it does not provide the list of file without
>>  files under its sub directories.
>
> What kind of fix do you mean? We could detect if there's a directory in
> the list of arguments and assume the recursive mode. I think this is
> what most users expect.

As per BTRFS-FILESYSTEM(8)
  :
---------
Note
Directory arguments without -r do not defragment files recursively but 
will defragment certain internal trees (extent tree and the subvolume 
tree). This has been confusing and could be removed in the future.
---------

  I was thinking the following as a fix..
    without -r: apply it on the extent tree (current behavior)
                (and probably add a warning as you suggest below).
    with -r only: error, and say also use (new) per-file option -x,
                  (instead of applying on all files of dir in arg and
                  its sub-dir. [*])
    with -x: apply it on all the files in the dir in the arg
    with -xr: apply it on all files in the dir in the arg and
              its sub-dir.

> Currently passing a directory will defragment the extent tree, but I
> think we should extend the defrag ioctl flags to explictly ask for that.

  I am ok with this approach as well, which means,
    without -r: apply it on all files in dir. (instead of current way
                of applying on the extent tree. [*])
    with -r: apply it on all files in dir and its sub-dir.
    with -e (new): apply it on extent tree.

  [*] changes the current cli semantics

> At minimum, a directory without -r could print a warning about what it's
> really doing. But I'm open to other ideas.

  agreed.

  (was on vacation sorry for the delay).


Thanks, Anand
