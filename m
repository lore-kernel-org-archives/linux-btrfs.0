Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:29877 "EHLO
        smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753746AbeDPNC0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 09:02:26 -0400
Received: from [95.208.211.112] (helo=localhost)
        by smtprelay03.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux-btrfs@stefan-klinger.de>)
        id 1f83VG-0003JX-KL
        for linux-btrfs@vger.kernel.org; Mon, 16 Apr 2018 14:45:02 +0200
Date: Mon, 16 Apr 2018 14:45:02 +0200
From: Stefan Klinger <linux-btrfs@stefan-klinger.de>
To: linux-btrfs@vger.kernel.org
Subject: Unclear `btrfs subvolume snapshot` command
Message-ID: <20180416124501.GA24667@tauhou>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using

    # btrfs version
    btrfs-progs v4.16


In btrfs-subvolume(8), I find the description of the `snapshot`
command unclear:

    snapshot [-r] <source> <dest>|[<dest>/]<name>

I find the preference of `|` is unclear.  From the text passage

    If only <dest> is given, the subvolume will be named the basename
    of <source>.

I infer, that `<source>` must be there even “if only <dest> is given”.
Also, it's unclear how the cases

    snapshot [-r] <source> <dest>
    snapshot [-r] <source> [<dest>/]<name>

are told apart.  I assume it's based on whether `<dest>` is an
existing directory.  I came to this from the rather unfortunate error
message

    ERROR: invalid snapshot name '/'

when trying

    # btrfs subvolume snapshot / /foo

where `/foo` already existed.  It took me some time to arrive at the
conclusion that `btrfs` took this as the `<source> <dest>` case, and
tried to make a subdir `/` under `/foo`, which is, of course, illegal.

May I suggest the following changes:

  * in the manual, change to:
  
        snapshot [-r] <source> <dest>
            Create a snapshot of the subvolume <source>.

            If <dest> is an existing directory, the snapshot will be
            named <dest>/<basename of source>.  Note that this is
            illegal if <source> is `/`.

            If <dest> does not exist, it will be created, and this
            will be the snapshot.

  * in `btrfs subvolume`:  Change the error message from

        ERROR: invalid snapshot name '/'

    to

        ERROR: '<dest>' exists, but cannot create snapshot named '/'
        under it.  Specify explicit snapshot name.

IMHO it would be better to replace an existing <dest> with the
snapshot, instead of creating one under it.  It would solve above
problem, and also be more similar to how `mount` handles a mountpoint.

Thank you,
Stefan


-- 
http://stefan-klinger.de                                      o/X
Send plain text messages only, not exceeding 32kB.            /\/
                                                                \
