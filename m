Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33896 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbcF1UMZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 16:12:25 -0400
Received: by mail-vk0-f48.google.com with SMTP id c2so37864714vkg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 13:11:50 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>
Date: Tue, 28 Jun 2016 23:11:19 +0300
Message-ID: <CAHj_TLC5Fgzkd49wvU-6WDO-mbqnZs6MUwxje+0vowCcUJLmsw@mail.gmail.com>
Subject: btrfs-check: Fix bitflipped keys from bad RAM
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

A patch with this subject was submitted in May 2014:
http://www.spinics.net/lists/linux-btrfs/msg33777.html

I don't see it among any of the ~360 open issues at
https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&component=btrfs

Unless somebody objects, I'll file it as a NEW issue with patch.


I think the work done by Hugo Mills for this one is important and it
would be a pity if those patches were forgotten. It is one of those
things where btrfs could outperform zfs, which has not bitflip
recovery. Btrfs could have one, and it would be great.

I personally came across a machine with a bitflipped index and I would
love to test these patches. I am however reluctant to invest time in
it if there is no issue in the bug tracker and no visible progress.
Without proper tracking all debugging/feedback would go in vain.
