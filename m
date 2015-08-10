Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36127 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335AbbHJWwE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 18:52:04 -0400
Received: by vkbf67 with SMTP id f67so7126673vkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 15:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
Date: Mon, 10 Aug 2015 16:52:02 -0600
Message-ID: <CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Four needed things:
- kernel version
- btrfs-progs version
- complete dmesg for the failed mount
- complete btrfs check output (you mostly have this but since the
version isn't included, it's not clear this is the entire output)

The last two can be included as attachments in a bugzilla.kernel.org
bug report and the URL posted in this thread. Typically MUA wrapping
nerfs the dmesg making it hard to read, so attachments to a bug report
are better.

Bugs get reported both in bugzilla and on the list.
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F

Sometimes it takes a while for devs to respond, they also get worked
on even without responses just because there's so many improvements
each release.


-- 
Chris Murphy
