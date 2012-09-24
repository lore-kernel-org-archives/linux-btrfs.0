Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:34119 "HELO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755768Ab2IXQni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 12:43:38 -0400
Received: by weyt9 with SMTP id t9so330023wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 09:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120924151203.GI14582@twin.jikos.cz>
References: <CA+nK0aON8yROCGwetiXdEphUf+Ju-BVJ54ooeMOZyUpHy9KDGA@mail.gmail.com>
 <20120924140239.GB6136@carfax.org.uk> <20120924151203.GI14582@twin.jikos.cz>
From: Sami Haahtinen <sami@haahtinen.name>
Date: Mon, 24 Sep 2012 19:43:16 +0300
Message-ID: <CA+nK0aMQdoO56R_YpuQjw=7iuee2ReFCwLw853RYXV1jU2a6hg@mail.gmail.com>
Subject: Re: Rebuilding chunk root?
To: dave@jikos.cz, Hugo Mills <hugo@carfax.org.uk>,
        Sami Haahtinen <sami@haahtinen.name>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 6:12 PM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Sep 24, 2012 at 03:02:39PM +0100, Hugo Mills wrote:
> >    Out of interest, does mounting with -o recovery help at all? (I'm
> > not expecting it to do much if your chunk tree's gone, but it might do
> > something).
>
> The -o recovery has access to the respective tree roots, but the
> contents may be destroyed already. The chunk tree is not deep, I can see
> height 1 on a 6 disk array (though lightly used, 1 node, 8 leaves) and 3
> disk array (1/7 TB used, 1 node, 29 leaves). So it's quite a small
> amount of data to destroy the chunktree completely, COW will lower the
> chances a bit.

Yeah, the whole tree is gone, I'm pretty sure of it since the first
20-50GB has been wiped from the drive and the mentioned address is in
the beginning of that part. I just wonder if there is any chance of
the older versions of the chunk tree still being somewhere and how to
find them. I doubt it's an easy feat though.

> Rebuilding from scratch does not look simple, the available information
> is stored in BLOCK_GROUP_ITEMs or INODE_ITEMs and covers portions of the
> chunks. Given that the device tree would be probably damaged as well,
> the amount of information to do cross-check is not high. Maybe replaying
> the chunk creation logic can save some guesswork.

Replaying chunk creation logic would not help that much, since the
drive has been resized a few times and had other operations that have
modified the chunk tree as well. The array itself is not that complex
(2 drives), but it's still not as simple as a single drive array.

Regards,
--
Sami Haahtinen
Bad Wolf Oy
+358443302775
