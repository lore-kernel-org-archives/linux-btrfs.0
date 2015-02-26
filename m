Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:39454 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbBZVtw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 16:49:52 -0500
Received: by wesx3 with SMTP id x3so15104214wes.6
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2015 13:49:51 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 26 Feb 2015 22:49:51 +0100
Message-ID: <CAG-aW06oJ3NB1zOZ0NuAmLK36kOdKKJhQgJhKCZmVtpAqbZXrA@mail.gmail.com>
Subject: Btrfs fixes, changes don't appear on git repo
From: Matt <jackdachef@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clm@fb.com>, jbacik@fb.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi linux-btrfs list,

Hi Chris, Hi Josef,


it seemingly happened in the past and now it seems to happen again:

after patches have been posted to the linux-btrfs mailing list and
pulled by Linus,

changes occured and additional pull-requests followed - the old
commits don't appear to be anywhere accessible besides Linus' tree


example:

http://marc.info/?l=linux-btrfs&m=142203898505309&w=2

[GIT PULL] Btrfs fixes
from January 23rd


I picked a specific patch out:
http://marc.info/?l=linux-btrfs&m=142141473603234&w=2
Btrfs: fix race deleting block group from space_info->ro_bgs list

since it might lead to lockups

I've seen some lockups in the past few days which involved Btrfs while
playing and adding some bleeding edge patches to my custom kernel
(3.19 based) - or in general to have Btrfs' latest and greatest code

thus I want to make sure that I have the latest
stability-/bugfix-related patches


When searching at
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/
for "Btrfs: fix race deleting block group from space_info->ro_bgs list"

it winds up in Linus' repo with a merge/pull from January 24th
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=Btrfs%3A+fix+race+deleting+block+group+from+space_info-%3Ero_bgs+list


But when searching in the "integration" or current "for-linus" branch
http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/?h=integration
http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/?h=for-linus

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/?h=for-linus&qt=grep&q=Btrfs%3A+fix+race+deleting+block+group+from+space_info-%3Ero_bgs+list

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/?h=integration&qt=grep&q=Btrfs%3A+fix+race+deleting+block+group+from+space_info-%3Ero_bgs+list

There is no such commit - which I can't seem to wrap my head around

The same result with

git log --grep "foo ..."

after having fetched the latest state of Chris' repo


Am I missing something ?

It would be really nice to have a repo where all of the latest Btrfs
patches are stored and accessible - and a clear picture on why this
weirdness happens


Sorry if this was already asked in the past, since I'm not aware of
such a report


Many thanks in advance for your answers

Kind Regards

Matt
