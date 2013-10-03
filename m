Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64346 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3JCSee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Oct 2013 14:34:34 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so1092129bkg.22
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 11:34:33 -0700 (PDT)
Date: Thu, 3 Oct 2013 20:34:31 +0200
From: Christopher =?ISO-8859-1?Q?Kroo=DF?= <c.krooss@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs kernel bug while balancing
Message-Id: <20131003203431.35b0b9b98d90c9324c941d11@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I just encountered this kernel bug when I executed "btrfs balance start /". I'm sorry if this is not enough data but I couldn't save the log as my system didn't respond after the dmesg. It said "kernel bug" before the trace.

partial log: http://i.imgur.com/ygk3Nid.jpg

Regards,
Chris
-- 
Christopher Krooﬂ <c.krooss@gmail.com>
