Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36375 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbcAZGOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 01:14:38 -0500
Received: by mail-io0-f175.google.com with SMTP id g73so179698969ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:14:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
	<56A6082C.3030007@netcologne.de>
	<CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
	<CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
	<CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
	<CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
Date: Mon, 25 Jan 2016 23:14:37 -0700
Message-ID: <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1495MiB used raid6 in a VM using 4x qcow2 files on an SSD.
Host is using kernel 4.4.0
Guest is using kernel 4.5.0rc0.git9.1.fc24 (this is a Fedora Rawhide
debug kernel so it'll be a bit slower), btrfs-progs 4.3.1

Not degraded, balance takes 11 seconds, that's ~136MiB/s
iotop isn't consistent, max is ~300MiB/s write.

Reboot with 1 device missing and a new empty qcow2 in its place, mount
degraded and 'btrfs replace' takes 13 seconds according to 'btrfs
replace status'.

I don't know that this is very useful information though.

Christian, what are you getting for 'iotop -d3 -o' or 'iostat -d3'. Is
it consistent or is it fluctuating all over the place? What sort of
eyeball avg/min/max are you getting?


Chris Murphy
