Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35945 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbcHLPGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 11:06:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bYE2Q-0007ir-2z
	for linux-btrfs@vger.kernel.org; Fri, 12 Aug 2016 17:06:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Fri, 12 Aug 2016 15:06:16 +0000 (UTC)
Message-ID: <pan$c5e52$548e4e68$60e28d88$8f006dcd@cox.net>
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
	<35417d9d-c3e4-6a3a-50e0-bdd91bf39f80@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 12 Aug 2016 08:04:42 -0400 as
excerpted:

> On a file server?  No, I'd ensure proper physical security is
> established and make sure it's properly secured against network based
> attacks and then not worry about it.  Unless you have things you want to
> hide from law enforcement or your government (which may or may not be
> legal where you live) or can reasonably expect someone to steal the
> system, you almost certainly don't actually need whole disk encryption.
> There are two specific exceptions to this though:
> 1. If your employer requires encryption on this system, that's their
> call.
> 2. Encrypted swap is a good thing regardless, because it prevents
> security credentials from accidentally being written unencrypted to
> persistent storage.

In the US, medical records are pretty well protected under penalty of law 
(HIPPA, IIRC?).  Anyone storing medical records here would do well to 
have full filesystem encryption for that reason.

Of course financial records are sensitive as well, or even just forum 
login information, and then there's the various industrial spies from 
various countries (China being the one most frequently named) that would 
pay good money for unencrypted devices from the right sources.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

