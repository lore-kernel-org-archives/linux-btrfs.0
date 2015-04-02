Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38522 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbDBPtE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 11:49:04 -0400
Received: by igbqf9 with SMTP id qf9so76527624igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 08:49:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2015 17:49:04 +0200
Message-ID: <CA+4EQ5dko+dSy6aFtx3cyUUXNR493aCHDE1A=MGb9FjnWQjwWA@mail.gmail.com>
Subject: SSD mode on HDD
From: Petr Bena <benapetr@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I figured out that for some reason on both ubuntu and debian, SSD mode
seems to be turned on even on HDD's (hard disk drives - eg. those with
rotating disk). I figured out now, but it's been like this for at
least a year or more and I didn't really had any problems with this.

Is it OK to have SSD mode enabled on HDDs?
