Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:48273 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISAmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 20:42:07 -0400
Received: by mail-io0-f180.google.com with SMTP id n69so6358841ioi.5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 17:42:07 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Mon, 18 Sep 2017 20:41:45 -0400
Message-ID: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
Subject: difference between -c and -p for send-receive?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

new subject for new question

On Mon, Sep 18, 2017 at 1:37 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:

> >> What scenarios can lead to "ERROR: parent determination failed"?
> >
> > The man page for btrfs-send is reasonably clear on the requirements
> > btrfs imposes. If you want to use incremental sends (i.e. the -c or -p
> > options) then the specified snapshots must exist on both the source and
> > destination. If you don't have a suitable existing snapshot then don't
> > use -c or -p and just do a full send.
> >
>
> Well, I do not immediately see why -c must imply incremental send. We
> want to reduce amount of data that is transferred, so reuse data from
> existing snapshots, but it is really orthogonal to whether we send full
> subvolume or just changes since another snapshot.
>

Starting months ago when I began using btrfs serious, I have been
reading, rereading and trying to understand this:

FAQ - btrfs Wiki
https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_difference_between_-c_and_-p_in_send.3F

The comment above suddenly gives me another clue...

However, I still don't understand terms like "clone range ioctl",
although I can guess it is something like a hard link.

Would it be correct to say the following?

1. "-c" causes (appropriate) files in the newly transferred snapshot
to be "hard linked" to existing files in another snapshot on the
destination. Doesn't "-p" do something equivalent though?

2. The -c and -p options can be used together or individually.

Questions:

If "-c" "will send all of the metadata of @B.1, but will leave out the
data for @B.1/bigfile, because it's already in the backups filesystem,
and can be reflinked from there" what will -p do in contrast?

Will "-p" not send all the metadata?

Will "-p" also leave out the data for @B.1/bigfile, when it's also
already in the backups?

What would make me choose one of these options over the other? I still
struggle to see the difference.
