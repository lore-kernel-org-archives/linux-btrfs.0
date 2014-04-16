Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:43545 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161089AbaDPPBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 11:01:47 -0400
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id 1DBA4D80D1
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 17:01:46 +0200 (CEST)
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net [151.189.21.46])
	by mail-in-12-z2.arcor-online.net (Postfix) with ESMTP id 119612E6233
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 17:01:46 +0200 (CEST)
Received: from athene.mittagstun.de (dslb-084-061-021-231.pools.arcor-ip.net [84.61.21.231])
	(Authenticated sender: mwilck@arcor.de)
	by mail-in-06.arcor-online.net (Postfix) with ESMTPA id E217010BB21
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 17:01:45 +0200 (CEST)
Message-ID: <534E8B6A.9060209@arcor.de>
Date: Wed, 16 Apr 2014 15:53:46 +0200
From: Martin Wilck <mwilck@arcor.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Lost /home subvolume after btrfs crash
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a broken btrfs file system on a laptop.

Debug material is available here:
  https://www.dropbox.com/sh/utv8b3qd0do6a04/zTwGQCrN9x

Most importantly, the /home subvolume is lost. All attempts to recover
data from it (btrfs-restore, mount -o recovery, btrfsck) have failed so
far (/home is simply empty in the btrfs-restore output), although I was
able to recover most of the other subvolumes and the main FS. The btrfs
tools would typically segfault with failed assertions when analyzing the
FS. Grepping through the entire volume shows that (at least parts of)
/home are still available, but they seem to be disconnected from the
main tree somehow, or the meta data is so corrupt that the tools bail
out trying to find files under it. Making matters worse, the important
data was encrypted using ecryptfs, so I need to recover the ciphertext
first and then find a way to recover the plaintext (I do have the
passphrase).

The crash happened with a rather old OpenSUSE 12.2 kernel (3.4.11-2.16).
The user says she was just surfing the web normally when the crash
occured (no screenshot of the original crash, unfortunately). On the
next boot,  the btrfs root file system couldn't be mounted any more.
After that I booted an OpenSUSE 12.3 rescue DVD and created the debug
material shown above.

Any hints how to retrieve files from the /home subvolume from this
corrupt file system would be highly appreciated.

Best regards
Martin
