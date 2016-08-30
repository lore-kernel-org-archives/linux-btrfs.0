Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35335 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932856AbcH3RoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 13:44:07 -0400
Received: by mail-oi0-f48.google.com with SMTP id p186so1365579oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 10:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGf6y9iMH8y9=f94R7Chy3dKPbJYy+q4G69BceWcHqLb_SdeKQ@mail.gmail.com>
References: <CAGf6y9gUcEqMDnuhnE77edUja-LdkaEGpoY3pNL5+vrmq3K7tA@mail.gmail.com>
 <CANhjow9n6FqHpK8y2zvfwq8-ptVHJMs4=+tP1qy1hNu-5veF3g@mail.gmail.com>
 <CAGf6y9jQvi5Ev1KJ3Ksci8bnm6EneDW30FbdDgXSNjDM7gVTww@mail.gmail.com>
 <CANhjow88qnD+C9+YSA9g+sXBocTKykN=ykYqPvpK8=h1mLKU=w@mail.gmail.com> <CAGf6y9iMH8y9=f94R7Chy3dKPbJYy+q4G69BceWcHqLb_SdeKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 30 Aug 2016 11:44:04 -0600
Message-ID: <CAJCQCtRvONH2vkhzTM55h-YdY_P23PkGYE1jZF=5JgJOFexQ-A@mail.gmail.com>
Subject: Re: Raid 5 to raid 1: balance hangs and scrub aborts. Is this salvageable?
To: h.gersen@gmail.com
Cc: Justin Kilpatrick <jkilpatr@redhat.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well it looks like metadata corruption, if it were just a case of data
corruption there'd be a file name path associated with the checksum
mismatch error; and in that case you'd be able to just delete the file
(or first extract a copy of it it with btrfs restore) and then it
wouldn't trigger csum errors anymore, and replace it with a confirmed
good copy later.

Also, btrfs check by itself doesn't check data extent csums, only
metadata csums. So again it sounds like there's a corrupt leaf and for
whatever reason it's not being fixed up by parity. And Btrfs really
obsinate about continuing on, especially read-write mounted, once
there's a csum error in metadata that it can't fix from parity or
another copy. And even XFS now will also go read only in similar
circumstances. It's just that its repair is a lot older and has some
ways to infer metadata when it's missing or bad, and Btrfs check
hasn't gotten that far yet. I think one of the future tests for btrfs
check when it hits csum errors is the ability to test if the outcome
is plausible if it assumes the metadata is actually good and it's the
csum itself that's bad. Or to iterate plausible variations of metadata
that cause the csum to match. And if it all works out then to CoW the
rebuilt metadata.

Anyway, fixing this would be really tedious with the existing tools.
You'd need to iterate some portions of this leaf to get it to match
its csum; or just change the csum to match the metadata as it is right
now, and then see if things work again. It's a reasonably good idea
though to just delete any associated file, because that will cause its
metadata to go away also, and the source of this problem. But often a
leaf or node will contain references to more than just one file.


-- 
Chris Murphy
