Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35872 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcBJTQL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 14:16:11 -0500
Received: by mail-ig0-f173.google.com with SMTP id xg9so20648252igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 11:16:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56BB38D4.6030008@netcologne.de>
References: <56A230C3.3080100@netcologne.de>
	<56A6082C.3030007@netcologne.de>
	<CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
	<CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
	<CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
	<CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
	<CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
	<56A73460.7080100@netcologne.de>
	<CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
	<56A7CF97.6030408@gmail.com>
	<CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
	<56A88452.6020306@netcologne.de>
	<56A8F18E.3070400@gmail.com>
	<CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
	<56AF676B.2070902@netcologne.de>
	<CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
	<56B9EE1E.2040000@netcologne.de>
	<CAJCQCtTPQE+hBzaktURR1v3GtObSjH=UV806qU-RmFVomwK3GA@mail.gmail.com>
	<56BB38D4.6030008@netcologne.de>
Date: Wed, 10 Feb 2016 12:16:10 -0700
Message-ID: <CAJCQCtRnpZZXruuX3iMuG7RsN0tcEa3R6W4NNnvkYsBpVrrNzA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://fpaste.org/320720/45511028/

What is rb_next? See if you can explode that out and find out more
about why there's so much time going on with that. I see that rb_next
gets used for lots of things, including btrfs. In mine, rb_next is
less than 1% overhead, but for you it's the top item. That's
suspicious.


http://fpaste.org/320718/10016145/
line 72-73. We both have counts for qgroup stuff. Mine is much much
less than yours. I have never had quotas enabled on any of my
filesystems, so I don't know why there are any such counts at all. But
since your values are nearly three orders of magnitude greater than
mine, I have to ask if you have quotas enabled or have ever had them
enabled? That might be a factor here...



Chris Murphy
