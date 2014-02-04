Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub0-omc1-s35.dub0.hotmail.com ([157.55.0.234]:40718 "EHLO
	dub0-omc1-s35.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaBDK47 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 05:56:59 -0500
Message-ID: <DUB130-W6707D22BE962A3F4EF70B29CAA0@phx.gbl>
From: David Binderman <dcb314@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [cmds-scrub.c:539]: (style) Array index 'i' is used before limits
 check.
Date: Tue, 4 Feb 2014 10:48:46 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

Static analyser cppcheck says many things
about btrfs-progs, including the subject line.

Source code is

            while (isspace(l[i]) && i < avail) {

Suggest code rework. I checked the latest source
code and the bug exists there too.

Regards

David Binderman 		 	   		  