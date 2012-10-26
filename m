Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:35602 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab2JZMaJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 08:30:09 -0400
Message-ID: <508A824E.805@jan-o-sch.net>
Date: Fri, 26 Oct 2012 14:30:06 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG in btrfs_set_item_key_safe
References: <508A2F3F.3030500@jan-o-sch.net> <20121026121941.GB23729@shiny>
In-Reply-To: <20121026121941.GB23729@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, October 26, 2012 at 14:19 (+0200), Chris Mason wrote:
> On Fri, Oct 26, 2012 at 12:35:43AM -0600, Jan Schmidt wrote:
>> Hi,
>>
>> while running extensive qgroup and tree mod log tests I got to the following
>> BUG, which is probably not related to tree mod log:
> 
> So our keys are out of order...are you able to reproduce this?

No reproducer yet. My tests ran fine for about 15 hours before that happened.
I'll have an extensive amount of (tree mod log related) debug information if I
should get there again.

My guess is that it's not related to tree mod log, though, as there are tree log
functions (fs/btrfs/tree-log.c) on the stack. I don't think rewinded buffers can
make it there.

I'll call back when I'll hit this again.

-Jan
