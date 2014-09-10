Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39979 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaIJQoL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 12:44:11 -0400
Received: by mail-vc0-f177.google.com with SMTP id la4so2335796vcb.36
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 09:44:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Sep 2014 18:44:10 +0200
Message-ID: <CAFvQSYQBTViupkLThmaxXNQ8is1ohO-3+0E=wwwP1WdETtHz5w@mail.gmail.com>
Subject: Deadlock with 3.15.10
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've recently run into a deadlock on 3.15.10, don't know if the kernel
stack-trace is useful: http://pastebin.com/guQNDAMX

Br, Clemens
