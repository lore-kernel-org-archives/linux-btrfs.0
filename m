Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cartman.its.monash.edu.au ([130.194.13.166]:49757 "EHLO
	cartman.its.monash.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792Ab2JCP3p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 11:29:45 -0400
Received: from jones.its.monash.edu.au ([130.194.13.86])
 by cartman.its.monash.edu.au
 (Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
 with ESMTP id <0MBB00305PPIGQB0@cartman.its.monash.edu.au> for
 linux-btrfs@vger.kernel.org; Thu, 04 Oct 2012 01:29:42 +1000 (EST)
Received: from jones.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id B60F98BDE53	for
 <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2012 01:29:42 +1000 (EST)
Received: from mail-ie0-f174.google.com
 (mail-ie0-f174.google.com [209.85.223.174])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by jones.its.monash.edu.au (Postfix)
 with ESMTPS id 2C40B8BDE59	for <linux-btrfs@vger.kernel.org>; Thu,
 04 Oct 2012 01:29:41 +1000 (EST)
Received: by ieak13 with SMTP id k13so17456835iea.19 for
 <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 08:29:38 -0700 (PDT)
Date: Thu, 04 Oct 2012 01:29:38 +1000
From: Gordon Ng <gfng1@student.monash.edu>
Subject: Re: [Btrfs-next] bulid failure at fs/btrfs/ctree.h
In-reply-to: <20121002141404.GU14582@twin.jikos.cz>
To: dave@jikos.cz, Gordon Ng <gfng1@student.monash.edu>,
        linux-btrfs@vger.kernel.org
Message-id: <CAJ09SM_j7==v_CH0O5v+GKEXdWGVgzNYQ6o4ADnF+2y=3Kt=Uw@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
 <20121002141404.GU14582@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David,
I compared the source code and found that I did have a merge conflict.
This is now resolved and now builds fine.

Thanks,
Gordon

On 3 October 2012 00:14, David Sterba <dave@jikos.cz> wrote:
> On Tue, Oct 02, 2012 at 10:50:26PM +1000, Gordon Ng wrote:
>> Hello Josef,
>>
>> FYI build failure occured in fs/btrfs/ctree.h.
>>   CC      fs/btrfs/super.o
>> In file included from fs/btrfs/delayed-inode.h:30:0,
>>                  from fs/btrfs/super.c:45:
>> fs/btrfs/ctree.h:3235:1: error: expected identifier or ?(? before ?<<? token
>
> Can you please paste the sources from your tree? It's possible that it's
> leftover from a local merge conflict.
>
> From my fresh 3.6 tree:
>
> 3232 static inline void btrfs_force_ra(struct address_space *mapping,
> 3233                                   struct file_ra_state *ra, struct file *file,
> 3234                                   pgoff_t offset, unsigned long req_size)
> 3235 {
> 3236         page_cache_sync_readahead(mapping, ra, file, offset, req_size);
> 3237 }
>
>
> david
