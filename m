Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47500 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbaDNQu7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:50:59 -0400
Received: by mail-ob0-f173.google.com with SMTP id wn1so1835814obc.4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 09:50:58 -0700 (PDT)
MIME-Version: 1.0
From: Shaun Reich <sreich@kde.org>
Date: Mon, 14 Apr 2014 12:50:18 -0400
Message-ID: <CADVynFCg4KWN9AGNKXAjoamwoLfNO4Q5czv+UCdEhqXWrG8P8A@mail.gmail.com>
Subject: sub del: directory not empty, even though it is
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

attempting to restructure my fs snapshots the proper way, previous way
was like this:

(subvol=0)
boot
etc
var
...
SNAPSHOTS/01-16-14/{boot,etc,dev, proc..}
SNAPSHOTS/03-22-14... etc

i removed all but the 01-16-14 via sub del. i then thought 'i don't
want the data at top-level anyways as its a botched upgrade, so i'll
just revert to the last snapshot via a mv.

so i rm'd everything at top level except snapshots, cd
snapshots/01-16-14;mv * ../..

now an ls -a at the dated dir shows empty, my files are where they
should be so i really just want this to be gone. and a sub list on the
top-level mount path lists:

# btrfs sub list -ta /mnt/1
ID      gen     top level       path
--      ---     ---------       ----
291     199502  5               SNAPSHOTS/01-16-14

yet, oddly enough btrfs sub del really doesn't want to delete it, even
though it's entirely empty and not in use either.

# btrfs sub del /mnt/1/SNAPSHOTS/01-16-14
Transaction commit: none (default)
Delete subvolume '/mnt/1/SNAPSHOTS/01-16-14'
ERROR: cannot delete '/mnt/1/SNAPSHOTS/01-16-14' - Directory not empty


-- 
Shaun Reich,
KDE Software Developer (kde.org)
