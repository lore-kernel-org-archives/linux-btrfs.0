Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60914 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbeCCHBq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Mar 2018 02:01:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1es18p-0007f3-Ht
        for linux-btrfs@vger.kernel.org; Sat, 03 Mar 2018 07:59:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs space used issue
Date: Sat, 3 Mar 2018 06:59:26 +0000 (UTC)
Message-ID: <pan$bee0f$57d3b021$cd11cf8a$d3c1d93d@cox.net>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
        <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
        <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
        <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
        <CAFmraXhRtUh-HPV4vpeE3-0B=vCeK40b2HfsOk_boSFu+EjQhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

vinayak hegde posted on Thu, 01 Mar 2018 14:56:46 +0530 as excerpted:

> This will happen over and over again until we have completely
> overwritten the original extent, at which point your space usage will go
> back down to ~302g.We split big extents with cow, so unless you've got
> lots of space to spare or are going to use nodatacow you should probably
> not pre-allocate virt images

Indeed.  Preallocation with COW doesn't make the sense it does on an 
overwrite-in-place filesystem.  Either nocow it and take the penalties 
that brings[1], or configure your app not to preallocate in the first 
place[2].

---
[1] On btrfs, nocow implies no checksumming or transparent compression, 
either.  Also, the nocow attribute needs to be set on the empty file, 
with the easiest way to do that being to set it on the parent directory 
before file creation, so it's inherited by any newly created files/
subdirs within it.

[2] Many apps that preallocate by default have an option to turn 
preallocation off.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

