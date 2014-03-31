Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61309 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCaSPp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 14:15:45 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so5082544wes.5
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 11:15:43 -0700 (PDT)
Received: from gmail.com (tor-exit-01.thehappy3.com. [178.63.97.34])
        by mx.google.com with ESMTPSA id t50sm34683429eev.28.2014.03.31.11.15.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Mar 2014 11:15:42 -0700 (PDT)
Subject: [Help] Errors found in extent allocation tree or chunk allocation
Date: Mon, 31 Mar 2014 17:39:05 -0000
From: Michael Witten <mfwitten@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Firstly, it should be noted that I can mount and use my Btrfs file
system with nary an error or warning; however, I'm uncomfortable
using it while it's in some kind of inconsistent state.

The `btrfsck' tool is telling me the following:

  Errors found in extent allocation tree or chunk allocation

In particular, I'm receiving 69158 messages of the following form:

  Extent back ref already exists for <a> parent <b> root <c>

All of those are followed by the same number of messages of the
following form:

  ref mismatch on [<d> 4096] extent item <e>, found <f>
  Incorrect global backref count on <d> found <e> wanted <f>
  backpointer mismatch on [<d> 4096]

I've run several commands in an attempt to repair/recover the file
system, but nothing seems to help.

What is the meaning of these errors, and how should I fix them?

Sincerely,
Michael Witten
