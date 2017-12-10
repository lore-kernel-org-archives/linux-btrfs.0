Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:35738 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdLJVQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 16:16:42 -0500
Received: by mail-qt0-f172.google.com with SMTP id u10so33611070qtg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 13:16:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com> <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com> <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com> <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com> <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
From: Benjamin Beichler <hadrian2002@googlemail.com>
Date: Sun, 10 Dec 2017 21:16:21 +0000
Message-ID: <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
Subject: Re: Chunk-Recovery fails with alignment error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch let the chunk-recover be successful. But I'm no lucky man,
the recovered chunk tree does not work or other metadata is also
broken.

Mounting the system is not successful (dmesg):
BTRFS critical (device dm-0): corrupt node, invalid item slot:
block=16384, root=1, slot=0
BTRFS error (device dm-0): failed to read chunk root
BTRFS error (device dm-0): open_ctree failed

Therefore I tried a btrfs check --repair, this time without error:
https://gist.github.com/anonymous/5cf7ad9e187032d2c94db4f91bb62c24

Then I tried btrfs check --init-extent-tree and this produces much
output. I put the beginning into here:
https://gist.github.com/anonymous/70e2482646a8235ee2327105d920dadd
>From a fast view, the messages keep to be similar to the last of the
gist, but the messages in the beginning are not repeating. If it helps
I have complete compressed log.

Then I tried a btrfs recover to get files, but for many files (also
improtant data, but I filtered the output) I get outputs like in:
https://gist.github.com/anonymous/1cc7f7ab5af33e76d0bf80960bb300eb

Any new suggestions?
