Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:34039 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbbHCQWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 12:22:54 -0400
Received: by ykax123 with SMTP id x123so114924365yka.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 09:22:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
	<CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
Date: Mon, 3 Aug 2015 12:22:54 -0400
Message-ID: <CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sonic <sonicsmith@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output of btrfs check:

btrfs check /dev/sdc
warning, device 2 is missing
bytenr mismatch, want=20971520, have=0
Couldn't read chunk root
Couldn't open file system

btrfs check /dev/sde
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
bytenr mismatch, want=20971520, have=8330001001141004672
Couldn't read chunk root
Couldn't open file system

In case the above helps.
