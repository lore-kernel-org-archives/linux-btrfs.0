Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57757 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2FEJQC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 05:16:02 -0400
Received: by dady13 with SMTP id y13so7051801dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 02:16:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvYUW1jbJCirNSde_A78-_K_5x+kGoOV_hQ-0O51UxuhXA@mail.gmail.com>
References: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
	<CAB9VWqAoc=+9B5FLtVbDY8xWeRt+O8oJ79BQKtdhOMjMAYu2eA@mail.gmail.com>
	<CAGEjNMf5hU4wteJepU5h4r=HXs_Anf_RGawHpphq=ft76Raw=Q@mail.gmail.com>
	<CAB9VWqAbh1GEbbvbm0MjOPCocX3K7B5yVynH1VYMWV-rN_CZ7Q@mail.gmail.com>
	<CAHf9xvYUW1jbJCirNSde_A78-_K_5x+kGoOV_hQ-0O51UxuhXA@mail.gmail.com>
Date: Tue, 5 Jun 2012 11:16:01 +0200
Message-ID: <CAB9VWqCPHP7My9wH1pp1cXevm_T7R+mWrtgj+mprJApPhqViKA@mail.gmail.com>
Subject: Re: inquiry on btrfs send/receive
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: shyam btrfs <shyam.btrfs@gmail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 4, 2012 at 7:33 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
>
> Yes, I also noticed that sometimes transid gets bumped up, but there
> is no actual change.
>
> So let's say you identify that a particular part of the tree is not
> shared anymore, and, say, eventually you get to a particular leaf
> within that part of the tree. How would you detect that, say, a
> particular INODE_ITEM (or, more difficult, an INODE_REF) is missing
> from that leaf WRT to previous tree?
>
> The property you described perhaps suggests another method to find
> leafs, in which *something* has changed. (Although within a leaf, does
> it make sense to decode all items and to look at their transid - those
> that have them - to filter out even more?) And yes, perhaps, looking
> at transid alone will bring more such potential leafs into
> consideration.
>
> However, how does this property help to determine *what* actually has
> changed between the two trees? Like, for example, being able to tell
> over which range of keys there possibly was a change, and iterate
> within that range?
When doing incremental sends, we always have two trees at hand. One
where we know that it is already on the receiving side (we did already
send it) and the one that we want to send now. To find the changes, we
simply compare those trees. If an items misses on one tree, we know
it's either new or deleted (depending on the tree the item lies in).

I would suggest you to not put too much work into send. As already
said, the btrfs send/receive patches are close to be posted to the
mailing list. It's currently reviewed and when I get a "looks good now",
I'll post it.
>
> Alex.
