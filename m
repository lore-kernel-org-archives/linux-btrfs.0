Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752052AbeENIg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 04:36:29 -0400
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: Roman Mamedov <rm@romanrm.net>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180514070210.27047-1-wqu@suse.com>
 <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
Date: Mon, 14 May 2018 11:36:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180514132004.3afec300@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.05.2018 11:20, Roman Mamedov wrote:
> On Mon, 14 May 2018 11:10:34 +0300
> Nikolay Borisov <nborisov@suse.com> wrote:
> 
>> But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
>> the inode flags, presumably the admin knows what he is doing?
> 
> Please don't. Personally I always assumed chattr +C would prevent both CoW and
> compression, and used that as a way to override volume-wide compress-force for
> a particular folder. Now that it turns out this wasn't working, the patch
> would fix it to behave in line with prior expectations.


So what made you have these expectation, is it codified somewhere
(docs/man pages etc)? I'm fine with that semantics IF this is what
people expect.


Now the question is why people grew up to have this expectation and not
the other way round? IMO force_compress should really disregard
everything else, if not then it should be documented. The man pages [0]
say:

"
If compress-force is specified, the compression will allways be
attempted, but the data may end up uncompressed if the compression would
make them larger.

As this is too simple, the compress-force is a workaround that will
compress most of the files at the cost of some wasted CPU cycles on
failed attempts. The heuristics of compress will improve in the future
so this will not be necessary.
"

In this case I think the man page for this option should be documented
to say that inode-specific flags preclude mount flags.

https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)#MOUNT_OPTIONS

