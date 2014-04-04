Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaDDQcI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 12:32:08 -0400
Date: Fri, 4 Apr 2014 18:32:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
Message-ID: <20140404163207.GY29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
 <20140404155346.GX29256@twin.jikos.cz>
 <CAL3q7H5V1OjW8nerpCuNUB+8FhjPV+4hXPQf81QBtU3PQypgjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5V1OjW8nerpCuNUB+8FhjPV+4hXPQf81QBtU3PQypgjQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 04, 2014 at 05:01:41PM +0100, Filipe David Manana wrote:
> >>   * Send a clone command to user space.
> >>   */
> >> --- a/fs/btrfs/send.h
> >> +++ b/fs/btrfs/send.h
> >> @@ -87,6 +87,7 @@ enum btrfs_send_cmd {
> >>
> >>       BTRFS_SEND_C_END,
> >>       BTRFS_SEND_C_UPDATE_EXTENT,
> >> +     BTRFS_SEND_C_TOTAL_DATA_SIZE,
> >
> > Though it is a simple modification, it changes the existing send
> > protocol.
> >
> > The unpatched receiver would fail (it has a lower value of
> > __BTRFS_SEND_C_MAX), so it could work even without revving the protocol.
> > But, it's not the cleanest way.
> 
> Same problem happened when BTRFS_SEND_C_UPDATE_EXTENT was added.

That's a good example why objecting from the beginning is wise, because
it will backfire later. You can blame me that I did not object back
then, but was involved in the patch reviews.

> Since it's a command that's only sent if a new special flag is
> supplied, I don't think it's that bad.

Yeah it's not that bad and I don't want to stand in the way of a good
enhancement. The flag makes it better wrt backward compatibility.

> > There's a number of defficiencies found in v1 protocol, see
> > https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft
> >
> > I would rather see a proper v2 revision instead of relying on the fact
> > that current implementation will deal with the change.
> 
> Right, by 2020 we'll have v2 fully specified and maybe implemented :)

I saw that coming :)

We're not waiting for a full v2 spec, but someone who implements what's
been collected so far. And because it also includes implementing the
versioning infrastructure, it's not that attractive compared to adding
one more TLV command.

So, if others thing this is ok for v1, proceed.
