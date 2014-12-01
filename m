Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63011 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaLAQkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 11:40:05 -0500
Received: by mail-qa0-f52.google.com with SMTP id dc16so7289080qab.25
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 08:40:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201184621.5dd7fcd9@natsu>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com> <20141201184621.5dd7fcd9@natsu>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Mon, 1 Dec 2014 22:09:44 +0530
Message-ID: <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 7:16 PM, Roman Mamedov <rm@romanrm.net> wrote:
>
> A more sensible idea could be adding a global-level '-i' switch, same as in
> 'rm', so that you or distros could then alias 'btrfs' to 'btrfs -i' (ask
> confirmation on any irreversible action).

Well the difference being that there doesn't seem to be any other
irreversible action from my scan of man btrfs -- am I missing
anything? This is the only thing that actually leads to loss of data.

When btrfs has so many features (esp snapshots) to prevent user
accidentally deleting data (I liked especially
http://www.youtube.com/v/9H7e6BcI5Fo?start=209) I think there has to
be *some* modicum of support for warning against deleting a subvolume
(and it seems others agree too).

But I see what you mean in the bugzilla comment about not wanting your
existing backup snapshot scripts to fail because they don't have a -f.
At the same time, aliasing via -i on top level btrfs binary may not be
so practical here because this is the only command which will actually
use it (again, correct if wrong).

Perhaps exporting some envvar in the default shell's rc file (or
whichever file will be read only if the shell is interactive) would
work? Like in ~/.bashrc:

export BTRFS_SUBVOLUME_DELETE_CONFIRM=1

Ideas?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
