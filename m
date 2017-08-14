Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:35856 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751000AbdHNS6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 14:58:01 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs-progs-v4.12: cross compiling
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Hallo32 <Hallo32@gmx.net>, linux-btrfs@vger.kernel.org
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
 <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
 <20170814140341.GU2866@suse.cz>
 <159b3db0-6eae-7cff-d166-3c4b0c2513ac@gmx.com>
 <20170814151052.GV2866@twin.jikos.cz>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <340e3677-4abd-5390-58bb-a64160a31862@libero.it>
Date: Mon, 14 Aug 2017 20:57:57 +0200
MIME-Version: 1.0
In-Reply-To: <20170814151052.GV2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2017 05:10 PM, David Sterba wrote:
> On Mon, Aug 14, 2017 at 10:14:42PM +0800, Qu Wenruo wrote:
[...]
> mktables.c is synced from kernel sources, taking updates from there is
> easier than porting any changes to the proposed scripted implementation.
> 
> The workflow is simple:
> - copy kernel mktables.c changes to btrfs-progs mktables.c

How the kernel deals with this kind of problem ? 
Looking at the source of btrfs Makefile, it is more simple to replace

  mktables: kernel-lib/mktables.c
        @echo "    [CC]     $@"
        $(Q)$(CC) $(CFLAGS) $< -o $@

with


  mktables: kernel-lib/mktables.c
        @echo "    [HOSTCC] $@"
        $(Q)$(HOSTCC) $(CFLAGS) $< -o $@

where HOSTCC is defined as

HOSTCC=gcc


(may be the same applied also to CFLAGS <-> HOSTCFLAGS ?)

> - compile mktables
> - run 'make kernel-lib/tables.c'
> - commit the changes to git
> 
> All of that happens very rarely, if ever, the raid56 tables and
> correction algorithms are set in stone. Any extensions need to be done
> on both sides kernel/userspace.
> 
>>>> What about using script to generate it?
>>>
>>> We do have the mktables utility to generate it and I'll regenerate it
>>> should there be a change to kernel-lib/mktables.c
>>
>> I mean to replace mktables.c with a script.
>> So no cross compiler problems at all, and even easier Makefile.
>> No dependence on "mktables" program.
> 
> Somebody has to implement the script and verify that the output is the
> same, eventually sync changes. The cross-compilation should be fixed
> with the pregenerated tables.c . Is Makefile size really a concern? The
> number of related lines is like 7. I don't see any benefit in what you
> propose and hopefully explained my viewpoint enough so I don't have to
> continue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
