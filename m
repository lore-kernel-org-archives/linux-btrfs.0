Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35955 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbcAAQG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 11:06:58 -0500
Received: by mail-wm0-f47.google.com with SMTP id l65so106807276wmf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 08:06:57 -0800 (PST)
Received: from orione.localnet (183.Red-83-50-202.dynamicIP.rima-tde.net. [83.50.202.183])
        by smtp.gmail.com with ESMTPSA id pn6sm73985531wjb.15.2016.01.01.08.06.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Jan 2016 08:06:56 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs send / receive freeze system - Addendum
Date: Fri, 01 Jan 2016 16:06:55 +0000
Message-ID: <1616501.4qyDSaKgzl@orione>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forgot to mention that this freeze is happening after I converted 
this backup drive to btrfs, before it was XFS. So sending to XFS drive didn't 
caused the freeze while sending with the same script to btrfs formatted drive 
freeze the system. Kernel and btrfs progs were the same.

Regards.
