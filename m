Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35036 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbELBhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 21:37:16 -0400
Received: by ieczm2 with SMTP id zm2so124021478iec.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 18:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F645954A2D259@Server.waterlogic.com.au>
References: <554F6D43.2060806@googlemail.com>
	<CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com>
	<554F963D.2040209@googlemail.com>
	<201505111141.54771.russell@coker.com.au>
	<555145EA.6040009@googlemail.com>
	<B7F2379062E32745A8651FBDB20F645954A2D259@Server.waterlogic.com.au>
Date: Mon, 11 May 2015 19:37:15 -0600
Message-ID: <CAJCQCtT-ZdFqwjCjS5sH1zG=xT3Ok4V1VYBf4NeQ3QPxsZgtRA@mail.gmail.com>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
From: Chris Murphy <lists@colorremedies.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two file systems involved, guest and host. What are their
file systems? I know one of them is Btrfs but I can't tell if they're
both Btrfs.

There is a regression somewhere, I don't know where yet, when libvirt
cache=none or cache=directsync, and the disk image (qcow2 in my case)
is on Btrfs. The guest file system doesn't matter, it'll eventually
spew some corruption related errors.
https://bugzilla.redhat.com/show_bug.cgi?id=1204569


Chris Murphy
