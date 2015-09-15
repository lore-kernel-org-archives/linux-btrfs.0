Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36503 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIOUA3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 16:00:29 -0400
Received: by lbcao8 with SMTP id ao8so91688585lbc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 13:00:27 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 15 Sep 2015 22:59:48 +0300
Message-ID: <CAGqmi77Y3qiEs7aVwXQ-VT9b0yF4ViAA1szMicY5_GEXQaRYVw@mail.gmail.com>
Subject: Csum I/O Error
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,
i've catch a io error, caused by csum mismatch
Can i force fs to read data?
This is really not a cool, if only way is use btrfs restore.

#Info vm machin, after power failure get 2 blocks with errors, and one
mysql table, can't be readed by mysql (and also, i can't just dump it)

-- 
Have a nice day,
Timofey.
