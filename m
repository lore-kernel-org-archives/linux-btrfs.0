Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:39415 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcBJNTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 08:19:21 -0500
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Chris Murphy <lists@colorremedies.com>
References: <56A230C3.3080100@netcologne.de> <56A6082C.3030007@netcologne.de>
 <CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
 <CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
 <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
 <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
 <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
 <56A73460.7080100@netcologne.de>
 <CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
 <56A7CF97.6030408@gmail.com>
 <CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
 <56A88452.6020306@netcologne.de> <56A8F18E.3070400@gmail.com>
 <CAJCQCtT9NZdaJ8MKHQw-1ARi7PkLeq_p9dtdZaPYdLt8EpTcbA@mail.gmail.com>
 <56AF676B.2070902@netcologne.de>
 <CAJCQCtS1gX4jbnpjmgnGn2WE5TTfHnSfeyQioDwRL4vgZrXMhA@mail.gmail.com>
 <56B9EE1E.2040000@netcologne.de>
 <CAJCQCtTPQE+hBzaktURR1v3GtObSjH=UV806qU-RmFVomwK3GA@mail.gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56BB38D4.6030008@netcologne.de>
Date: Wed, 10 Feb 2016 14:19:16 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPQE+hBzaktURR1v3GtObSjH=UV806qU-RmFVomwK3GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey btrfs-folks,


I did a bit of digging using "perf":


1)
 * "perf stat -B -p 3933 sleep 60"
 * "perf stat -e 'btrfs:*' -a sleep 60"
 -> http://fpaste.org/320718/10016145/



2)
 * perf record -e block:block_rq_issue -ag" for about 30 seconds:
 -> http://fpaste.org/320719/51101751/raw/


3)
* perf top
 -> http://fpaste.org/320720/45511028/






Regards

Christian
