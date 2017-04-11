Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36369 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbdDKTPn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 15:15:43 -0400
Received: by mail-oi0-f54.google.com with SMTP id r203so8088449oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 12:15:38 -0700 (PDT)
MIME-Version: 1.0
From: Amin Hassani <ahassani@chromium.org>
Date: Tue, 11 Apr 2017 12:15:32 -0700
Message-ID: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
Subject: Btrfs disk layout question
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am working on a project with Btrfs and I was wondering if there is
any way to see the disk layout of the btrfs image. Let's assume I have
a read-only btrfs image with compression on and only using one disk
(no raid or anything). Is it possible to get a set of offset-lengths
for each file or metadata parts of the image. I know there is an
unfinished documentation for On-disk Formant in here:
https://btrfs.wiki.kernel.org/index.php/On-disk_Format
But it is not complete and does not show what I am looking for. Is
there any other documentation on this? Is there any public API that I
can use to get this information. For example can I iterate on all
files starting from the root node and get all offset-lengths? This way
any part that doesn't come can be assumed as metadata. I don't really
care what is inside the metadata, I just want to know their
offset-lengths in the file system.

Thank you,
Amin.
