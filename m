Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54728 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755396AbdBGVFf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 16:05:35 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbCvm-0006H9-8U
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 22:04:06 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 21:54:08 +0100
Message-ID: <20170207215408.65030acd@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
        <91c8a758-23b6-edf1-74b0-2d87acbb2560@gmail.com>
        <20170207211941.3310d7a8@jupiter.sol.kaishome.de>
        <6d7eac16-773e-bf6c-a6be-d3950f9b2325@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 15:27:34 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> >> I'm not sure about this one.  I would assume based on the fact that
> >> many other things don't work with nodatacow and that regular defrag
> >> doesn't work on files which are currently mapped as executable code
> >> that it does not, but I could be completely wrong about this too.  
> >
> > Technically, there's nothing that prevents autodefrag to work for
> > nodatacow files. The question is: is it really necessary? Standard
> > file systems also have no autodefrag, it's not an issue there
> > because they are essentially nodatacow. Simply defrag the database
> > file once and you're done. Transactional MySQL uses huge data
> > files, probably preallocated. It should simply work with
> > nodatacow.  
> The thing is, I don't have enough knowledge of how defrag is
> implemented in BTRFS to say for certain that ti doesn't use COW
> semantics somewhere (and I would actually expect it to do so, since
> that in theory makes many things _much_ easier to handle), and if it
> uses COW somewhere, then it by definition doesn't work on NOCOW files.

A dev would be needed on this. But from a non-dev point of view, the
defrag operation itself is CoW: Blocks are rewritten to another
location in contiguous order. Only metadata CoW should be needed for
this operation.

It should be nothing else than writing to a nodatacow snapshot... Just
that the snapshot is more or less implicit and temporary.

Hmm? *curious*

-- 
Regards,
Kai

Replies to list-only preferred.

