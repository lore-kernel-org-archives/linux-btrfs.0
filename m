Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752513AbcHaW3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 18:29:06 -0400
Subject: Re: [PATCH] btrfs: remove pointless debugfs interface
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
 <20160831190858.GJ16983@twin.jikos.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d3e6540b-903d-4d35-e7b0-07a41f1feec5@redhat.com>
Date: Wed, 31 Aug 2016 16:38:16 -0500
MIME-Version: 1.0
In-Reply-To: <20160831190858.GJ16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/31/16 2:08 PM, David Sterba wrote:
> On Wed, Aug 31, 2016 at 10:13:49AM -0500, Eric Sandeen wrote:
>> A /sys/kernel/debug/btrfs/test file was added nearly
>> two and a half years ago, but it serves no purpose;
> 
> It does. Introduced in 1bae30982bc86ab66d61ccb6e22792593b45d44d says
> something about helping developers to easily export information from the
> filesystem, to aid debugging. Writing the debugfs support code is not
> obviously trivial, so it's idling in the source. Exporing a new value is
> as easy as copy and update 3 lines of code. If you have no use for it,
> fine.

I had thought that Documentation/filesystems/debugfs.txt would suffice,
but if you keep stuff lying around in btrfs just in case somebody needs
to export a global variable in the future, I suppose that's cool too.  ;)

>> it stores and returns a value, but nothing in the btrfs
>> code uses this value in any way.  There are no other btrfs
>> files in this debugfs dir.
>>
>> This was brought to my attention because it is world-writable;
>> it is the only such file under /sys/kernel/debug, and without
>> knowledge of its purpose, some users were alarmed by this.
> 
> So let's fix the permissions.

*shrug* ok.

-Eric

