Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35348 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdCONJa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 09:09:30 -0400
Received: by mail-wm0-f46.google.com with SMTP id u132so10373749wmg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 06:09:29 -0700 (PDT)
MIME-Version: 1.0
From: Alexandr Unger <ungerware.biz@gmail.com>
Date: Wed, 15 Mar 2017 15:09:28 +0200
Message-ID: <CAJmZ+t=pf16pdyogpAQdLB1oxhT_tntkkFQxCvw_0uv6am0Y=Q@mail.gmail.com>
Subject: claim of vtagfs feature
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi to everyone here!

Firstly thank you all for this amasing project!

I want to claim "virtual TAG file system" feature to be implemented in BTRFS.

What is it?

It is a feature to simplify use and search data (files) with common tags.

Some tags may be defined as a file attribute, like year of creation&|change
so user can access same file with different (virtual) paths like:

two diff files under ~/vtagfs/root/ :
firm1/reports/2016/report
firm1/reports/2017/report
(firm1/reports/2017/.tags/report or just .tags - sysfile with all tags
for this file/dir)
... and
2017/reports/firm1/report - will be link to second one

also may be set by default automatic lock to edit files with "old year
tag"... and so on...


How it can works.

/etc/vtagfs/ - place for global configs
~/.vtagfs/ - user space for configs

~/vtagfs/ - default or fixed place for data and links
~/vtagfs/.tags/ - place for data used by vtagfs itself
~/vtagfs/root/ - (root is fixed dir for all data operated by users'
vtagfs - to be known by other programs)
~/vtagfs/root/tag1/ - place for data with tag1 (only tag1)
~/vtagfs/root/tag1/.tag - file marker that this dir is used as a tag.
It maybe used to declare
possible sets of tags with this one.

~/vtagfs/root/tag1//tag2/ - place for data with tag1 & tag2
...
~/vtagfs/tag1/tag2 - slink showed to user
~/vtagfs/tag1/tag3 - slink showed to user
~/vtagfs/tag2/tag1 - slink showed to user
~/vtagfs/tag2/tag3 - slink showed to user
~/vtagfs/tag1/tag2/tag3/ - slink showed to user
...
Sure, must be something like tagManager to define/operate with tags
used by user.

or/and it can be realized as transparent to user/system requests like mkdir, so
mkdir tag1 inside ~/vtagfs/  will create tag1...
and cp file1 tag1/tag2/tag3/ - will set these tags to file1 ...
      ... and make cp file1 ~/vtagfs/root/tag1/tag2/tag3/ where will
be real place of file, known to system.

Hope this feature will be useful, so thank you all for patience :)

Best regards,

Alexandr.

  l-in-k  . c o m
