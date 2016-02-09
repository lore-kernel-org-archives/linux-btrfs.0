Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36721 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbcBIWCM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 17:02:12 -0500
Received: by mail-io0-f181.google.com with SMTP id l127so2326014iof.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 14:02:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160209224341.5bfa20b7@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
	<87mvr9euhb.fsf@vostro.rath.org>
	<20160209224341.5bfa20b7@jupiter.sol.kaishome.de>
Date: Tue, 9 Feb 2016 15:02:11 -0700
Message-ID: <CAJCQCtS9QN_xKeUe+v25Q6uMAknkoajsU8KKXmHej5fsuUPcUg@mail.gmail.com>
Subject: Re: Use fast device only for metadata?
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 9, 2016 at 2:43 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> Wasn't there plans for integrating per-file encryption into btrfs (like
> there's already for ext4)? I think this could pretty well obsolete your
> plans - except you prefer full-device encryption.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Encryption

I don't know whether the ZFS strategy (it would be per subvolume on
Btrfs) or the per directory strategy of ext4 is simpler. The simpler
it is, the more viable it is, I feel.

Maybe it's too much of a tonka toy to only encrypt file data, not
metadata (?) a question for someone more security conscious, but I'd
rather have some level of integrated encryption rather than none. So I
wonder if encryption could be a compression option - that is, it'd fit
into the compression code path and instead of compressing, it'd
encrypt. I guess the bigger problem then is user space tools to manage
keys. For booting, there'd need to be a libbtrfs api or ioctl for
systemd+plymouth to get the passphrase from the user. And for home, it
actually can't be in the startup process at all, it has to be
integrated into the desktop, using the user login passphrase to unlock
a KEK, and from there the DEK. The whole point of per directory
encryption is, a bunch of stuff remains encrypted.

If it were treated as a variation on compression, specifically a
variant of forced compression,  it means no key is needed to do
balance, scrub, device replace, etc, and even inline data gets
encrypted also. Open question if the metadata slot for compression is
big enough to include something like a key uuid, because each dir item
(at least) needs to point to the key needed to decrypt the data. Hmm,
or maybe a new tree to contain and track the encryption keys meant for
each dir item.

-- 
Chris Murphy
