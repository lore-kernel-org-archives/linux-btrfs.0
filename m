Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33112 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbcDDO6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 10:58:37 -0400
Message-ID: <57028107.5050707@osg.samsung.com>
Date: Mon, 04 Apr 2016 15:58:15 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        clm@fb.com, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH v4] btrfs: fix typo in btrfs_statfs()
References: <1459780282-6381-1-git-send-email-luisbg@osg.samsung.com> <20160404144547.GC3412@twin.jikos.cz>
In-Reply-To: <20160404144547.GC3412@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/16 15:45, David Sterba wrote:
> On Mon, Apr 04, 2016 at 03:31:22PM +0100, Luis de Bethencourt wrote:
>> Correct a typo in the chunk_mutex name to make it grepable.
>>
>> Since it is better to fix several typos at once, fixing the 2 more in the
>> same file.
>>
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> 
> Now the subject does not match the patch contents, but I can fix that so
> you don't have to resend it again.
> 

Sorry David. That was a poor decision by me of keeping the subject by
considering the typo in btrfs_statfs() as the core and the other two as
appended corrections.

Thank you for fixing it. I understand what you mean.

In an unrelated note, do you think this bug would be a good one for me
to tackle?
https://bugzilla.kernel.org/show_bug.cgi?id=115851

Thanks,
Luis
