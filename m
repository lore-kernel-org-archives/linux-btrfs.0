Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:39037 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbbECGTI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 May 2015 02:19:08 -0400
Received: by vnbg62 with SMTP id g62so12777175vnb.6
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2015 23:19:08 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 3 May 2015 08:19:07 +0200
Message-ID: <CAK5rZE55PB79N6CeSP-O3ugYfWR-u9dSemht_M6zVEG-KZu3YQ@mail.gmail.com>
Subject: Accessing Parent Subvolume
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a common case for installing new operating system on
subvolumes on an existing btrfs. So I'll base my example on it:

** SETUP **
We have the following subvolumes:

- OS1 (say Debian) on default subvolume /
- OS2 (say Arch) on subvolume /@arch

Now, boot into Arch and mount its parent
subvolume on /mnt/debian.


** QUESTIONS **
1- Is it safe to access /mnt/debian ?
2- Is it safe to access /mnt/debian/@arch ?
(Yeah, I'm pushing my chances recursively)


** POSSIBLE ANSWERS **
X- Sure.. Accessing parent subvolumes recursively is a
non issue. Even /arch/debian/arch/debian... is no problem.
(Then, add this to features/decumentation to show how
generic btrfs subvolume mount machinery is)

Y- Btrfs is designed to do that. However, expect some
corner cases/bugs. (It's okay)

Z- Don't even do that. Btrfs is never designed for it and
will never be. (Then, prevent user doing it)


I wonder where btrfs is on XYZ scale.

Thanks for your comments,
Imran
