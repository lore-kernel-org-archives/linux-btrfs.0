Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56943 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761819Ab2FVJGb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 05:06:31 -0400
Received: by vcbf11 with SMTP id f11so757006vcb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 02:06:30 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 Jun 2012 02:06:30 -0700
Message-ID: <CAK43AWvAeKzhR2pdpTxMLA=66BK6ErLBCVzPB3Cyy7X+_EjZEA@mail.gmail.com>
Subject: System Policy for Filenames
From: Aaron Peterson <myusualnickname@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs group:

 I would like to make a system policy that restricts the characters
used in a filename, tests filenames by regular expression, and
enforces case-insensitive-compatible exclusivity.

Where should I start?

I am trying to solve a few problems for my catproof Linux project.
* Compatibility with other systems.
* Protect users from   "-rf", or "*"  files that mess with shell
expansion and poorly written shell scripts.
* possibly ensure that I can type the filenames, and defend against
look-alike characters
(This would preferably just come up as a warning,  KDE converts a "/"
in a filename to a look-alike and broke my system, but I recognize
that I will need to access file names in multiple languages)


Thank you!
