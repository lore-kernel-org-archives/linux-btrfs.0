Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59194 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933979AbdDGPKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 11:10:50 -0400
Subject: Re: linux-next: Tree for Apr 7 (btrfs)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
References: <20170407182732.455c5c90@canb.auug.org.au>
 <3f143e53-652b-8690-d71c-dae42ab14a09@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b8b42950-e775-398d-1364-8bb7c117aa12@infradead.org>
Date: Fri, 7 Apr 2017 08:10:48 -0700
MIME-Version: 1.0
In-Reply-To: <3f143e53-652b-8690-d71c-dae42ab14a09@infradead.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/17 08:08, Randy Dunlap wrote:
> On 04/07/17 01:27, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20170406:
>>
> 
> on i386:
> 
> ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> 

or when built-in:

fs/built-in.o: In function `scrub_bio_end_io_worker':
scrub.c:(.text+0x3d1908): undefined reference to `__udivdi3'
fs/built-in.o: In function `scrub_raid56_parity':
scrub.c:(.text+0x3d23cc): undefined reference to `__udivdi3'
scrub.c:(.text+0x3d3342): undefined reference to `__udivdi3'
scrub.c:(.text+0x3d3755): undefined reference to `__udivdi3'


-- 
~Randy
