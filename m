Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35700 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbcEWM42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 08:56:28 -0400
Received: by mail-wm0-f42.google.com with SMTP id a136so20927113wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 May 2016 05:56:27 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 23 May 2016 15:55:47 +0300
Message-ID: <CAGqmi75qBPhqNCOoHNdSALqO8WkHfqo77qkXfhVm-GW3PyFrhQ@mail.gmail.com>
Subject: JFYI Lock-free Btree
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,
i just find this document:
http://www.cs.technion.ac.il/~erez/Papers/lfbtree-full.pdf

It's describe implementation of lock-free btree
I believe it's can be interesting for someone
(AFAIK btrfs use btree)
-- 
Have a nice day,
Timofey.
