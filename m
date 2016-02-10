Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34858 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbcBJCgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 21:36:11 -0500
Received: by mail-io0-f180.google.com with SMTP id d63so7895595ioj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 18:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSTNr7YGz+ASRBBOgtZEbPiBN-k8yWtUnUM-p4UXrsaFA@mail.gmail.com>
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
	<CAJCQCtSTNr7YGz+ASRBBOgtZEbPiBN-k8yWtUnUM-p4UXrsaFA@mail.gmail.com>
Date: Tue, 9 Feb 2016 19:36:10 -0700
Message-ID: <CAJCQCtSwLqp2--DNiJeJqJ0qWXzkP2cKKAAMid-VuNdEqNTPMQ@mail.gmail.com>
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

This could also be interesting. It means canceling the balance in
progress; waiting some time; and then cancelling it again to get
results to return.

# perf stat -B btrfs balance start /

## Again, single device example, balancing at expected performance.
http://fpaste.org/320562/55071438/

I didn't try this but, it looks like it'd be a variation on the above,
attaching to a running balance:

# perf stat -B -p <pidforbalance> sleep 60

Anyway...

Chris Murphy
