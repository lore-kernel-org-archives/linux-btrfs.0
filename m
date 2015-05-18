Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33527 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbERObg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 10:31:36 -0400
Received: by iebgx4 with SMTP id gx4so172079254ieb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 07:31:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5559D3D7.4020405@gmail.com>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
	<5559D3D7.4020405@gmail.com>
Date: Mon, 18 May 2015 08:31:35 -0600
Message-ID: <CAJCQCtSYgBXQOsw8BR78bXpZTYk5SYKnvyFu2zRf+KXfTzzDHg@mail.gmail.com>
Subject: Re: Btrfs and integration with GNU ++
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 18, 2015 at 5:58 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> While I don't know of any that use it by _default_ yet,

Since 5-6 months, openSUSE uses it by default for root fs (including
/boot). /home is on XFS. And snapper is configured to take snapshots
by default as well immediately before and after any system changes
(anything yast is in control of).


-- 
Chris Murphy
