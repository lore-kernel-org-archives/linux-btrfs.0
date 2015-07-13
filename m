Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38830 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbGMH7z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 03:59:55 -0400
Received: by wicmv11 with SMTP id mv11so54408160wic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 00:59:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <freemail.20150710060521.7704.1@fmxmldata04.freemail.hu>
References: <freemail.20150710060521.7704.1@fmxmldata04.freemail.hu>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Mon, 13 Jul 2015 09:59:34 +0200
Message-ID: <CAA7pwKPC=QjG6kTXsMqn+iTmLn20y7c4xWea+n948Yttbu9H0Q@mail.gmail.com>
Subject: Re: Can't remove missing device
To: None None <whocares0101@freemail.hu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 July 2015 at 06:05, None None <whocares0101@freemail.hu> wrote:
> According to dmesg sda returns bad data but the smart values for it seem fine.

> # smartctl -a /dev/sda
...
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Run smartctl -t long /dev/sda
