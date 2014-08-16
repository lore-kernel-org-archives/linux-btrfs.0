Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44436 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaHPKGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 06:06:50 -0400
Received: by mail-qg0-f41.google.com with SMTP id q107so3046582qgd.0
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Aug 2014 03:06:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Aug 2014 15:36:48 +0530
Message-ID: <CAH-HCWWvOKMEdPx8fK9oqr38iQqPo63vDkQBmxKrTixxur0BvA@mail.gmail.com>
Subject: Advisability of using nocow via chattr +C
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I am new to BTRFS, and I don't have it actually running on my
system as of yet, at least not for serious data. I am actually
hesitating whether or not to take the plunge and entrust my data to
this new FS.

I have been reading various articles on the wiki, lwn.net and
elsewhere re this FS. One thing I read was an advice to mark large
files requiring frequent random changes (such as databases or VBox
images) as nocow using chattr +C as to avoid fragmentation.

However, it is also my understanding that BTRFS avoids having to use a
journal because it does COW, whereby new data is written in empty
space and the new metadata pointing to this new data is also written
in empty space, and finally the file pointer points to the new
metadata, freeing up the old data/metadata blocks. (Correct me if I am
wrong.)

In this case, I am wondering whether using nocow will not affect my
image adversely as far as data safety is concerned (and this is more
important than avoiding fragmentation). Say the VBox image is being
written to directly by overwriting the blocks, but the writing is not
yet complete, and the system crashes, wouldn't that potentially leave
my image in an unusable state?

If the image were in COW mode, then all the new writes would be done
to a separate block/extent and probably the metadata would not be
updated or something, whereby the VBox image was just left in its
older (usable) state without the newer modifications written. If the
FS had journaling, there would be a different way to provide crash
resistance.

But since BTRFS doesn't have journaling, it seems that this suggestion
to disable COW on the image file to avoid defragmentation would only
make it vulnerable to data corruption.

Comments please? Thanks!

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
