Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43835 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751137AbdCCBPD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 20:15:03 -0500
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
 <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com>
 <14737660.8idzxVKBRv@thetick> <1689223.KKWey1OxT2@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e98d69c5-ac5e-d5b6-d7af-eb9c33975734@cn.fujitsu.com>
Date: Fri, 3 Mar 2017 09:09:57 +0800
MIME-Version: 1.0
In-Reply-To: <1689223.KKWey1OxT2@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/02/2017 05:44 PM, Marc Joliet wrote:
> On Wednesday 01 March 2017 19:14:07 Marc Joliet wrote:
>> In any
>> case, I started btrfs-check on the device itself.
>
> OK, it's still running, but the output so far is:
>
> # btrfs check --mode=lowmem --progress /dev/sdb2
> Checking filesystem on /dev/sdb2
> UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> ERROR: shared extent[3826242740224 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3826442825728 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3826744471552 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827106349056 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827141001216 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827150958592 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827251724288 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827433795584 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827536166912 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827536183296 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3827621646336 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3828179406848 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3828267970560 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3828284530688 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3828714246144 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3828794187776 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3829161340928 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3829373693952 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3830252130304 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3830421159936 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3830439141376 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3830441398272 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3830785138688 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831099297792 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831128768512 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831371513856 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831535570944 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831591952384 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831799398400 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831829250048 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3831829512192 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832011440128 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832011767808 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832023920640 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832024678400 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832027316224 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832028762112 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832030236672 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832030330880 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832161079296 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832164904960 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832164945920 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3832613765120 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3833727565824 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3833914073088 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3833929310208 4096] lost its parent (parent:
> 3827251183616, level: 0)
> ERROR: shared extent[3833930141696 4096] lost its parent (parent:
> 3827251183616, level: 0)

The "shared extent lost its parent" is all about the same extent, 
3827251183616.

It would be nice if you could paste the output of btrfs-debug-tree -b 
3827251183616 to check what tree it belongs to.

> ERROR: extent[3837768077312, 24576] referencer count mismatch (root: 33174,
> owner: 1277577, offset: 4767744) wanted: 1, have: 0
> [snip many more referencer count mismatches]
> ERROR: extent[3878247383040, 8192] referencer count mismatch (root: 33495,
> owner: 2688918, offset: 3874816) wanted: 2, have: 3

That's a little dangerous now.

Some *DATA* extent even lost its referencer now.

For example, data extent at 3837768077312, length 24K exists on disk, 
but no one is referring to it.

At least the good news is, these just mean there is some extra space 
taken on disk, but not vice verse.

> ERROR: block group[3879328546816 1073741824] used 1072840704 but extent items
> used 1129164800
> ERROR: extent[3879516581888, 40960] referencer count mismatch (root: 33530,
> owner: 1277577, offset: 23461888) wanted: 1, have: 0
> [snip many more referencer count mismatches]
> ERROR: extent[3951758860288, 16384] referencer count mismatch (root: 33189,
> owner: 1277577, offset: 519880704) wanted: 1, have: 0
>
> This is 56	lines of output, the unabridged output contains enough "referencer
> count mismatches" to fill 1329 lines of output.  Could that be because there
> are deleted snapshots that btrfs-cleaner hasn't been able to clean up?

Ah, this makes sense.

But normally cleaner should cleanup subvolume tree block and modify 
extent tree.
How did you stop btrfs-cleaner?

Thanks,
Qu
>
> Greetings
>


