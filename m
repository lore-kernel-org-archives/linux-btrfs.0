Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48330 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753823AbeCFTMT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:12:19 -0500
Subject: Re: How to change/fix 'Received UUID'
To: Marc MERLIN <marc@merlins.org>, Andrei Borzenkov <arvidjaar@gmail.com>,
        David Sterba <dsterba@suse.com>
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
 <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
 <20180305194718.GC613@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fdmanana@gmail.com
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com>
Date: Tue, 6 Mar 2018 20:12:15 +0100
MIME-Version: 1.0
In-Reply-To: <20180305194718.GC613@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2018 20:47, Marc MERLIN wrote:
> On Mon, Mar 05, 2018 at 10:38:16PM +0300, Andrei Borzenkov wrote:
>>> If I absolutely know that the data is the same on both sides, how do I
>>> either
>>> 1) force back in a 'Received UUID' value on the destination
>>
>> I suppose the most simple is to write small program that does it using
>> BTRFS_IOC_SET_RECEIVED_SUBVOL.
> 
> Understdood.
> Given that I have not worked with the code at all, what is the best 
> tool in btrfs progs, to add this to?
> 
> btrfstune?
> btrfs propery set?
> other?
> 
> David, is this something you'd be willing to add support for?
> (to be honest, it'll be quicker for someone who knows the code to add than
> for me, but if no one has the time, I'l see if I can have a shot at it)

If you want something right now that works, so you can continue doing
your backups, python-btrfs also has the ioctl, since v9, together with
an example of using it:

https://github.com/knorrie/python-btrfs/commit/1ace623f95300ecf581b1182780fd6432a46b24d

P.S. even when coding it in C, the documentation in that commit message
might be useful. :)

fwiw,
Hans
