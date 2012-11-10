Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4082 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2KJWcR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 17:32:17 -0500
Message-ID: <509ED5EF.6090506@shiftmail.org>
Date: Sat, 10 Nov 2012 23:32:15 +0100
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: High-sensitivity fs checker (not repairer) for btrfs
References: <509EC4B2.6090706@shiftmail.org> <20121110212317.GE29581@carfax.org.uk>
In-Reply-To: <20121110212317.GE29581@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/12 22:23, Hugo Mills wrote:
>     The closest thing is btrfsck. That's about as picky as we've got to
> date.
>
>     What exactly is your use-case for this requirement?

We need a decently-available system. We can rollback filesystem to 
last-known-good if the "test" detects an inconsistency on current btrfs 
filesystem, but we need a very good test for that (i.e. if 
last-known-good is actually bad we get into serious troubles).

So do you think btrfsck can return a false "OK" result? can it "not-see" 
an inconsistency?

Thank you
