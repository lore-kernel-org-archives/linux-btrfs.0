Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33727 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbCaWXZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 18:23:25 -0400
Received: by iebmp1 with SMTP id mp1so21704267ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 15:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20150331T232346-529@post.gmane.org>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
	<loom.20150331T232346-529@post.gmane.org>
Date: Tue, 31 Mar 2015 16:23:25 -0600
Message-ID: <CAJCQCtSmJ2BJxJqavnoJFCO6tGvDj8p4-BOSpnhH=2Smh5k=8A@mail.gmail.com>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
From: Chris Murphy <lists@colorremedies.com>
To: Benjamin Hodgetts <ben@xnode.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 3:24 PM, Benjamin Hodgetts <ben@xnode.org> wrote:
> G. Richard Bellamy <rbellamy <at> pteradigm.com> writes:
>
>>
>> When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
>> INFO: task mount:302 blocked for more than 120 seconds.
>> INFO: task btrfs-transacti:329 blocked for more than 120 seconds.
>>
>> I have an LTS Kernel at 3.14.35 that also fails to boot with the same
> behavior.
>>
>> My 3.18.6 works just fine.

Well there are only two backports in 3.14.35. Most of the ones found
in 3.19.2 are in 3.14.36.


commit f9e2ba638c32dff17ee6404e2c8245fd49d99b8b
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jan 2 18:45:16 2015 +0100

    btrfs: fix leak of path in btrfs_find_item

    commit 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756 upstream.

    If btrfs_find_item is called with NULL path it allocates one locally but
    does not free it. Affected paths are inserting an orphan item for a file
    and for a subvol root.

    Move the path allocation to the callers.

    Fixes: 3f870c289900 ("btrfs: expand btrfs_find_item() to include
find_orphan_item functionality")
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 74e42361fa3bc102647ad1e1ec7c21b747658843
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Dec 19 18:38:47 2014 +0100

    btrfs: set proper message level for skinny metadata

    commit 5efa0490cc94aee06cd8d282683e22a8ce0a0026 upstream.

    This has been confusing people for too long, the message is really just
    informative.


-- 
Chris Murphy
