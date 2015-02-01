Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:46218 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbBATHZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 14:07:25 -0500
Received: by mail-yh0-f47.google.com with SMTP id z6so14430050yhz.6
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 11:07:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <etPan.54ce76ff.327b23c6.4cb@Macadmins-MBP-5.smurfbo>
References: <etPan.54ce76ff.327b23c6.4cb@Macadmins-MBP-5.smurfbo>
Date: Sun, 1 Feb 2015 12:07:24 -0700
Message-ID: <CAJCQCtSC+VfKzyhVra3_goGSRbo8X74yaodSXqkW0Lvgw+fdnQ@mail.gmail.com>
Subject: Re: How to fix uncorrectable errors
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think more info is needed. What kernel and btrfs-progs versions have
been tried? What hardware? What is btrfs fi show and fi df <mp>? What
files, are there snapshots, etc? Is there any pattern to the two
cases, like the same types of files? And what are the kernel messages
for the above scrub (the entire scrub)?

When you say don't have any hardware issues, I'd like to think that
means an exhaustive (tedious) look at all kernel messages since the
last good scrub to see if there have been any libata or mount errors,
and smartctl -x shows no problems, and at some point in the life of
this machine's current configuration an exhaustive multiple day memory
test? Otherwise I don't know what no hardware issues means. The csum
errors not being fixed sounds like it's probably single copy data
corruption, is that correct? And are the files actually corrupt? Can
you extract them with btrfs restore and are they actually broken (if
this is even practically determinable)?

Chris Murphy
