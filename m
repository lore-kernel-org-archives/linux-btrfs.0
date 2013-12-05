Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59777 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LEJPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 04:15:15 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so2068384eek.29
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 01:15:14 -0800 (PST)
Received: from linux-suse.hu (BC06518D.dsl.pool.telekom.hu. [188.6.81.141])
        by mx.google.com with ESMTPSA id b41sm80247201eef.16.2013.12.05.01.15.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2013 01:15:13 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Date: Thu, 05 Dec 2013 10:14:50 +0100
Message-ID: <8479729.PFPMuy5jvX@linux-suse.hu>
In-Reply-To: <20131204021507.GH18095@localhost.localdomain>
References: <1531404.tFNCiHaLVH@linux-suse.hu> <20131204021507.GH18095@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Duncan,

Thank you for your advices!

Unfortunately I haven't found a good documentation on when I should use a 
cache_, that's why I thought "it's all the same, won't hurt" :).
Now, if this bug is fixed, I'll turn off the inode_cache, if it's unnecessary.

About autodefrag: yes, I'm considering running a total defragmentation on my 
whole drive ("/"), but unfortunately there is a bug which prevented me from 
doing it: it's a defrag panic which was fixed in 3.13.

So either I wait until that kernel is out or I start a rebalance. The latter 
seems better now :).

Thank you.

Ákos
Ps.: sorry for not replying to your letter in the thread but that didn't 
arrive in my mailbox.
