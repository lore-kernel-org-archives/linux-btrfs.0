Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35165 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbcBJCXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 21:23:11 -0500
Received: by mail-ig0-f182.google.com with SMTP id hb3so5155695igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 18:23:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPQE+hBzaktURR1v3GtObSjH=UV806qU-RmFVomwK3GA@mail.gmail.com>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
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
Date: Tue, 9 Feb 2016 19:23:10 -0700
Message-ID: <CAJCQCtSTNr7YGz+ASRBBOgtZEbPiBN-k8yWtUnUM-p4UXrsaFA@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
Cc: Christian Rohmann <crohmann@netcologne.de>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# perf stat -e 'btrfs:*' -a sleep 10


## This is single device HDD, balance of a root fs was started before
these 10 seconds of sampling. There are some differences in the
statistics depending on whether there are predominately reads or
writes for the balance, so clearly balance does predominately reads,
then predominately writes. Unsurprising but the three tries I did were
largely in agreement (orders of magnitude wise).
http://fpaste.org/320551/06921614/


# perf record -e block:block_rq_issue -ag
^C   ## after ~30 seconds
# perf report

## Single device HDD, balance of root fs start before perf record.
There's a lot of data, collapsed by default. I expanded a few items at
random just as an example. I suspect the write of the perf.data file
is a non-factor because it was just under 2MiB.
http://fpaste.org/320555/14550698/raw/


# perf top

## Single device HDD, balance of root fs start before issuing this
command, and let it run for about 20 seconds. This is actually not as
interesting as I thought it might be, but I don't really know what I'm
looking for. I'd need something else to compare it to.
http://fpaste.org/320559/55070873/


Anyway, all of these are single device, so it's not apples/apples
comparison, but it is a working (full speed for the block device)
balance.


Chris Murphy
