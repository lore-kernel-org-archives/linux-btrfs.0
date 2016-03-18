Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:33260 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbcCRRvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 13:51:48 -0400
Received: by mail-qg0-f66.google.com with SMTP id y89so7923033qge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:51:47 -0700 (PDT)
Subject: Re: [PATCH v2] btrfs-progs: add stat check in open_ctree_fs_info
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458309822-5550-1-git-send-email-ahferroin7@gmail.com>
 <20160318151714.GA21722@twin.jikos.cz>
Cc: clm@fb.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EC3FE4.5090608@gmail.com>
Date: Fri, 18 Mar 2016 13:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <20160318151714.GA21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-18 11:17, David Sterba wrote:
> On Fri, Mar 18, 2016 at 10:03:42AM -0400, Austin S. Hemmelgarn wrote:
>> There are other tools that have similarly poor error behavior when
>> called incorrectly (btrfs rescue immediately comes to mind), but they
>> don't use open_ctree_fs_info, so this doesn't affect them.  I may do
>> followup patches to fix those too if I have the time.
>
> Yeah, it would be good to fix all.
I had a bit of spare time over lunch, and decided to take a cursory 
look.  I hadn't realized that open_ctree uses open_ctree_fs_info, and it 
looks like almost everything that doesn't call open_ctree_fs_info calls 
open_ctree, which means this actually added error checking to a lot more 
than I realized, possibly everything that expects a filesystem image to 
operate on.  I've checked btrfs rescue now, and with this change, it now 
gives a nice error for something other than a a file or block device. 
It looks like a follow up patch may not be necessary after all, I'll try 
and double check the rest of the commands that I haven't checked already 
over the weekend, and hopefully have something by Monday or Tuesday if 
there's anything else that needs this check added.

