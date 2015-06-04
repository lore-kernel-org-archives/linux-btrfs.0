Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36861 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbFDOUp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 10:20:45 -0400
Received: by laei3 with SMTP id i3so32947915lae.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 07:20:44 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Thu, 4 Jun 2015 16:20:04 +0200
Message-ID: <CABgvyo9DJ9Z0EyAcdFLE9w+PTpheH9EOjzNy_0EUX+kYZFedOA@mail.gmail.com>
Subject: copy complete subvolume/snapshot structure
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I am wondering, what is the fastest und most secure way to copy a
complete btrfs-volume including the subvolume-structure to another
volume?
Just btrfs send/receive like this?
> btrfs send /vol1|btrfs receive vol2

Thanks in advance
Johan
