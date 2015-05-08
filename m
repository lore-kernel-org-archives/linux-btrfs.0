Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36508 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbEHKKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 06:10:06 -0400
Received: by wizk4 with SMTP id k4so23667080wiz.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 03:10:05 -0700 (PDT)
Received: from localhost ([195.246.228.99])
        by mx.google.com with ESMTPSA id di7sm8142004wib.23.2015.05.08.03.10.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 08 May 2015 03:10:04 -0700 (PDT)
Date: Fri, 8 May 2015 11:10:02 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub under linux with ck-patchset - oops
Message-ID: <20150508101002.GA3945@sune>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

Before I give all the information to this email and then find that's not
the right place to do so..

Does anyone experience issues with I/O intensive operations using btrfs
and BFQ io scheduler? I had a kernel panic while running (almost at the
start) a scrub and I glimpsed the elevator.c filename on the kernel dump
before I had to hard-reset.

If this is not the place to ask because maybe BFQ or ck patchset is not
supported under this list please let me know and I will redirect the
question elsewhere. Otherwise I can provide all informations to
reproduce it - it was reproducable.

Regards,
Leonidas

--
