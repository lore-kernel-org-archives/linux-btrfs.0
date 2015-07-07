Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38532 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbGGPq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 11:46:26 -0400
Received: by igrv9 with SMTP id v9so144012228igr.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 08:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKhV5s4=WR6t35Vo0JWekMKiv2ZOJF-py4sVSB4THZNd7cOe_Q@mail.gmail.com>
References: <CAKhV5s4=WR6t35Vo0JWekMKiv2ZOJF-py4sVSB4THZNd7cOe_Q@mail.gmail.com>
From: David Wilhelm <thefeshy@gmail.com>
Date: Tue, 7 Jul 2015 11:45:56 -0400
Message-ID: <CAKhV5s4M4fKgm+ZkCZHQL8QK20Oq19Nkj9CKOncjvFQbweY-Eg@mail.gmail.com>
Subject: Re: kernel crash on btrfs device delete missing
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Additional things I've tried:

btrfs scrub completes without errors

btrfs check runs through to cgroups without issue, then takes 100% of
CPU and runs off with it.

btrfs balance has exactly the same issue as delete - many warnings
regarding delayed-ref.c, followed by these two errors in extent-tree.c

http://pastebin.com/dNwGsy8j (linked because gmail seems to insist on
word wrapping)

Where can I go from here?
