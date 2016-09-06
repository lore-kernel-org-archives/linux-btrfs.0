Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35686 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934617AbcIFUiE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 16:38:04 -0400
Received: by mail-lf0-f50.google.com with SMTP id l131so61337062lfl.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 13:38:03 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Tue, 6 Sep 2016 22:32:28 +0200
Message-ID: <CAJF-kYmnBt6yRLJ+R3HdJ03oqp_ptwXpat40vXoD_b=MUvJZUw@mail.gmail.com>
Subject: State of the fuzzer
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm currently fuzzing rev 2076992 and things start to slowly, slowly
quiet down. We will probably run out of steam at the end of the week
when a total of (roughly) half a billion BTRFS-images have passed by.
I will switch revisions to current HEAD and restart the whole process
then. A few things:

* There are a couple of crashes (mostly segfaults) I have not reported
yet. I'll report them if they show up again with the latest revision.
* The coverage-analysis shows assertion failures which are currently
silenced. An assertion failure is technically a worse disaster
successfully prevented, it still constitutes unexpected/unusable
behaviour, though. Do you want assertions to be enabled and images
triggering those assertions reported? This is basically the same
conundrum as with BUG_ON and abort().
* A few endless loops entered into by btrfsck are currently
unmitigated (see bugs 155621, 155571, 155551 and 155151). It would be
nice if those had been taken care of by next week if possible.


Best regards
Lukas
