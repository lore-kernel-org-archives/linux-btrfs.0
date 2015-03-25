Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:34525 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbCYFZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 01:25:05 -0400
Received: by yhch68 with SMTP id h68so6951405yhc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 22:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150323211334.GA11155@ret.masoncoding.com>
References: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
	<20150323211334.GA11155@ret.masoncoding.com>
Date: Tue, 24 Mar 2015 23:25:04 -0600
Message-ID: <CAJCQCtRypOUTDcaftuQWCrHqH3mvkWe9bLZUvDva3bcEuRnjTw@mail.gmail.com>
Subject: Re: kvm bug, guest I/O blk device errors when qcow2 backing file is
 on Btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems like it may not be a kernel bug. I've been able to reproduce,
and not reproduce it, with kernel 3.18.9, varying in some other factor
(Fedora 21, vs Fedora 20 live installs).

The short version,

With these, the problem does not reproduce:
libvirt-* 1.1.3.9
qemu-* 1.6.1

With these, the problem does reproduce:
libvirt-* 1.2.9.1
qemu-* 2.1.2

I've updated the bug with the details of versions and the exact qemu
command for the reproducing and non-reproducing cases.
https://bugzilla.redhat.com/show_bug.cgi?id=1204569



Chris Murphy
