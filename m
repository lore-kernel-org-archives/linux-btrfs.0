Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932091AbdK1Tem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:34:42 -0500
Date: Tue, 28 Nov 2017 20:32:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About 'key type for persistent [...] items'
Message-ID: <20171128193244.GF3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
 <20171128173441.GZ3553@twin.jikos.cz>
 <344ca10c-39eb-0adb-3926-9ba6bf5a7229@mendix.com>
 <20171128191234.GD3553@twin.jikos.cz>
 <18237846-01f0-3177-a7ee-b254cd69e262@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18237846-01f0-3177-a7ee-b254cd69e262@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 08:28:58PM +0100, Hans van Kranenburg wrote:
> >> E.g. if I wanted to (just a random idea) add per device statistics, and
> >> use this, I'd need to use the key also with objectid 1, 2, 3, etc... if
> >> I have multiple devices. That's already a no go if there's anyone in any
> >> other tree that is doing anything with any objectid in the range of
> >> valid device numbers.
> > 
> > In that case there would be a new objectid PER_DEVICE_OBJECTID, with the
> > persistent key, and all the device ids can go to the offset field. The
> > objectid field should not be dynamic, by design.
> 
> Ok, didn't think of that yet, clear.
> 
> So... just a random idea...

You're not the first one to have that idea :)

> How cool would it be to have the block group items being done this
> way... PER_CHUNK_OBJECTID.
> 
> Imagine the time to mount a large btrfs filesystem going down from
> minutes or tens of minutes to just a few seconds...

Exactly for that reason, but in such case we're allowed to grab a new
key type and set objectid to a value that would group all the bg items,
mayb also moving the to the beginning of the key space.

The slightly tricky part would be the backward compatibility when we'd
have to keep the existing bg and new-bg in sync, but there are no
fundamental obstacles.
