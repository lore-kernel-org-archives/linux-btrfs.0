Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33863 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbeCETrT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 14:47:19 -0500
Date: Mon, 5 Mar 2018 11:47:18 -0800
From: Marc MERLIN <marc@merlins.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fdmanana@gmail.com
Subject: Re: How to change/fix 'Received UUID'
Message-ID: <20180305194718.GC613@merlins.org>
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org> <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 05, 2018 at 10:38:16PM +0300, Andrei Borzenkov wrote:
> > If I absolutely know that the data is the same on both sides, how do I
> > either
> > 1) force back in a 'Received UUID' value on the destination
> 
> I suppose the most simple is to write small program that does it using
> BTRFS_IOC_SET_RECEIVED_SUBVOL.

Understdood.
Given that I have not worked with the code at all, what is the best 
tool in btrfs progs, to add this to?

btrfstune?
btrfs propery set?
other?

David, is this something you'd be willing to add support for?
(to be honest, it'll be quicker for someone who knows the code to add than
for me, but if no one has the time, I'l see if I can have a shot at it)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
