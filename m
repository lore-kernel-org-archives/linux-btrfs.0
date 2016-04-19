Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36843 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcDSVnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 17:43:06 -0400
Received: by mail-wm0-f50.google.com with SMTP id v188so179564014wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 14:43:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5716130F.9050006@gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<5714D39B.90402@gmail.com>
	<CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
	<5714FA2F.6010207@gmail.com>
	<CAJCQCtTSdnD+n9UR7hWtqLdBzjb6WQXF71XKTgKJNgZPcdA3fg@mail.gmail.com>
	<571502B4.2050401@gmail.com>
	<CAD=QJKjhYoMOKkB1GA5EWONHifeBUpVH9-WgL9R_PozS+o+PLw@mail.gmail.com>
	<5716130F.9050006@gmail.com>
Date: Tue, 19 Apr 2016 17:43:03 -0400
Message-ID: <CAD=QJKjX+Q3d_pAGTxp6qU6A9-2ri3T+iLQ+hgfCOXjuVJVPxQ@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 April 2016 at 07:14, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> The closest I've ever seen for Debian to a Gentoo stage3 installation (the
> developers discourage usage of stage2 installs these days unless you're
> bootstrapping _everything_ yourself) is debbootstrap, and I could never get
> that to work reliably.

Fair, I remember Gentoo stage3+documentation was more straightforward
than debbootstrap+documentation.  There are a couple of wrappers
around debbootstrap and better documentation now, but I think there
are still rare times when bootstrapping from unstable or testing will
fail because a major transition is in progress (like the libc5 ->
libc6 transition, the ulibc -> glibc one, possibly the multiarch or
multilib transition, sometimes a GCC one, etc.)

> FWIW, the installer wasn't the only reason I switched to Gentoo, the two
> bigger ones for me were wanting newer software versions and needing
> different sets of features enabled on packages than the default builds, I
> ended up switching at the point that I was building more locally than I was
> installing from the repositories.

Ah yes, a convenient stream of fresh updates and the power of USE
flags :-)  For my needs, security-only updates + a backport whenever I
need a more up-to-date package of saves me time.  That's what the
choice of tool comes down to, right?  Does what you need it to, and
saves you time.

Best regards,
Nicholas
