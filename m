Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34131 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcBJTiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 14:38:24 -0500
Received: by mail-ig0-f179.google.com with SMTP id ik10so22022587igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 11:38:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnpZZXruuX3iMuG7RsN0tcEa3R6W4NNnvkYsBpVrrNzA@mail.gmail.com>
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
	<CAJCQCtRnpZZXruuX3iMuG7RsN0tcEa3R6W4NNnvkYsBpVrrNzA@mail.gmail.com>
Date: Wed, 10 Feb 2016 12:38:23 -0700
Message-ID: <CAJCQCtTGSQk+p0BNaKwvah0rLz2=hgSLkpCkG+TXnJbU1FyjoA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes when things are really slow or even hung up with Btrfs, yet
there's no blocked task being reported, a dev has asked for sysrq+t,
so that might also be something to issue while the slow balance is
happening, and then dmesg to grab the result. The thing is, I have no
idea how to read the output, but maybe if it gets posted up somewhere
we can figure it out. I mean, obviously this is a bug, it shouldn't
take two weeks or more to balance a raid6 volume.

I'd like to think this would have been caught much sooner in
regression testing before it'd be released, so it makes me wonder if
this is an edge case related to hardware, kernel build, or more likely
some state of the affected file systems that the test file systems
aren't in. It might be more helpful to sort through xfstests that call
balance and raid56, and see if there's something that's just not being
tested, but applies to the actual filesystems involved; rather than
trying to decipher kernel output. *shrug*


Chris Murphy
