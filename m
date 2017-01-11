Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33580 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938644AbdAKSLG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 13:11:06 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so29439609wme.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 10:11:05 -0800 (PST)
Subject: Re: [RFC PATCH 00/12] Refactor btrfs_inode VS inode in
 delayed-inode.c
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
 <20170111165100.GL12081@twin.jikos.cz>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <d38a7c95-dc0e-7fe9-ff77-7a5e0e51d70f@gmail.com>
Date: Wed, 11 Jan 2017 20:11:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170111165100.GL12081@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.01.2017 18:51, David Sterba wrote:
> On Tue, Jan 10, 2017 at 08:35:30PM +0200, Nikolay Borisov wrote:
>> After following the discussion in [1] I took a look at what's the 
>> state of VFS-related members being used in core BTRFS code. It turned 
>> out there are quite a few functions which operate on struct btrfs_inode, 
>> yet take struct inode. As a result they have to resort ot excessive 
>> usage of BTRFS_I, furthermore passing inode around doesn't help the 
>> poor reader inferring why inode might be passed to a particular function. 
>>
>> In order to better separate core btrfs functionalities from those part,
>> which interface with the VFS I took a look around the code and this is 
>> the result. I'd like to solicit opinions whether people think this 
>> refactoring is useful, since I have gathered a list of a lot more
>> functions which might use a bit of inode VS btrfs_inode changes. Also, 
>> a lot of function take inode just because btrfs_ino was taking an inode.
> 
> Agreed, this is a good direction how to clean up the code.
> 
>> The patches are self-explanatory, with the first one dealing with 
>> btrfs_ino being the bulk of it. This paves the way to restructuring 
>> a lot of functions. 
>>
>> If the maintainers think this should be merged I'd rather resend it 
>> as a single patch so as not to pollute the git history. This 
>> version can be used for fine-grained discussion and feedback. 
> 
> Actually I like the way it's separated as it keeps the review easy, it
> keeps the context in one function and does one change.
> 
> It would be interesting the see the result as reported by the 'size'
> utility before and after the patchset, the effects of removed BTRFS_I
> calls.

Actually without really doing the full-scale refactoring I expect the
results to be worse, due to the 147 added uses of BTRFS_I in the first
patch. But those are going to be only interim until everything is
cleaned up. Anyway, here are the numbers:

text	   data	    bss	    dec	    hex	filename
2530598	 174661	  28288	2733547	 29b5eb	fs/btrfs/btrfs.ko.nopatches

text	   data	    bss	    dec	    hex	filename
2530774	 174661	  28288	2733723	 29b69b	fs/btrfs/btrfs.ko.patches

So initially there is an increate of 176 bytes in the module but
hopefully this will go down.

> 
> I'll do a testing merge on top of current for-next to see how intrusive
> it is. If it turns out to be ok, I'll add the patches to the cleanups
> branch.
> 
