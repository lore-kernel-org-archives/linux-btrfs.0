Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33791 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdFJOi1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2017 10:38:27 -0400
Received: by mail-oi0-f54.google.com with SMTP id s3so39851512oia.0
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jun 2017 07:38:27 -0700 (PDT)
MIME-Version: 1.0
From: Hy Che <cvghy116@gmail.com>
Date: Sat, 10 Jun 2017 21:37:46 +0700
Message-ID: <CAE0+S6OjKesXZ65q5tVK7Y_Ydk7Q4Z8geEoQusr=7LVJHdUJGQ@mail.gmail.com>
Subject: Questions about how BtrFS works.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,
My name is Hy (ugen on freenode), I am a student attending GSoC for
Haiku[1]. Because I have a project that support write features for
BtrFS[2], there are some questions, since the documents on wiki are
not enough so I have to ask here.

1. Where can I find to read a complete btree manipulations in detail
(split, insert, etc) for BtrFS except the code base ?  I need to get
the idea first.

2. About the reference,  " ...with a refcount associated to each tree
node but stored in an ad-hoc free map structure ... " - wikipedia.
What is a free map structure, and where does it stored ?

3. How BtrFS allocate block and extent when cow-ed ? As I tested after
making a new file, the root tree root, extent root and csum root move
forward 65536 bytes, the fs root move 49152 bytes and the data extent
is allocated next to the previous one. Where those numbers come from ?
Is data extent is cow-ed ? I see it doesn't because extent-item still
contains the old offset.

4. How BtrFS handle transactions ?
Correctly me if I'm wrong, the transaction collect all requests in 30
seconds and then write back to disk. The transid increments when new
request appeared and genid is asigned to this one.

5. Why there is unused space (100 bytes) at the end of each node ?
6. How does BtrFS calculate checksum ?


[1]: About Haiku: www.haiku-os.org
[2]: My project info on GSoC:
https://summerofcode.withgoogle.com/projects/4749427110576128

Thanks,
Hy
