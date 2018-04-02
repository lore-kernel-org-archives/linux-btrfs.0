Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:40222 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbeDBMRO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 08:17:14 -0400
Received: by mail-io0-f169.google.com with SMTP id e79so17706652ioi.7
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Apr 2018 05:17:14 -0700 (PDT)
Subject: Re: Question, will ls -l eventually be able to show subvolumes?
To: Adam Borowski <kilobyte@angband.pl>, Pete <pete@petezilla.co.uk>
Cc: linux-btrfs@vger.kernel.org
References: <f8d1785e-0cad-29d7-4afa-af07bfe41530@petezilla.co.uk>
 <20180330163817.piz5pesm2al43uo5@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <58422ff4-904b-b464-bc28-43af3137dba1@gmail.com>
Date: Mon, 2 Apr 2018 08:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <20180330163817.piz5pesm2al43uo5@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-30 12:38, Adam Borowski wrote:
> On Fri, Mar 30, 2018 at 10:42:10AM +0100, Pete wrote:
>> I've just notice work going on to make rmdir be able to delete
>> subvolumes.  Is there an intent to allow ls -l to display directories as
>> subvolumes?
> 
> That's entirely up to coreutils guys.

Expanding on Adam's 100% accurate answer:

The primary issue here is that determining what is a subvolume requires 
some non-trivial work.  You either need to call a specific ioctl (and 
make sure you call it in the right location) which last I checked 
requires root privileges to use, or do some significant guess-work that 
happens to fall apart once you throw explicitly mounted subvolumes into 
the mix.

You can take a look at the `get_subvol_list` function in [1] for an 
example of what that guess-work looks like in Python.  That particular 
function relies on some specific internals of BTRFS that really aren't 
technically part of the ABI (namely that subvolumes all have an inode 
number of 256), but it falls apart if the subvolumes are explicitly 
mounted (because if you don't exclude explicit mounts, you may 
accidentally recurse into another BTRFS volume).

There's also a secondary issue in that the concept of a subvolume isn't 
really universal.  BTRFS and ZFS are the only filesystems supported on 
Linux that have such a concept, but ZFS datasets are a very different 
implementation of the concept that doesn't really make sense to mark 
with `ls`.  Given the level of specificity, it just doesn't make sense 
to mark subvolumes as such in `ls`, just like it doesn't make much sense 
to treat NILFS2 checkpoints any differently from read-only directories.


[1] 
https://raw.githubusercontent.com/Ferroin/btrfs-subv-backup/master/btrfs-subv-backup.py
