Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55120 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0M2W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 08:28:22 -0400
Received: by ghrr11 with SMTP id r11so821563ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 05:28:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEAF872.10507@grimmer.com>
References: <4FEAF872.10507@grimmer.com>
Date: Wed, 27 Jun 2012 06:20:14 -0600
Message-ID: <CAE5mzvhc-6S6AdY5uDxVqEegiTY_Sa3uFS-=1Ckit2T7rY4GOg@mail.gmail.com>
Subject: Re: Error compiling btrfs-tools from git (undefined reference to `pthread_create')
From: cwillu <cwillu@cwillu.com>
To: Lenz Grimmer <lenz@grimmer.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 6:11 AM, Lenz Grimmer <lenz@grimmer.com> wrote:
> On Ubuntu 11.10 "Oneiric" with gcc 4.6.1, compiling the btrfs tools from git
> fails for me with the following error:

Which git repo?
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
builds on ubuntu just fine (just checked on a fresh checkout), and
likewise the integration repo (but note that the integration repo's
master branch is not useful to build; you need to check out one of the
actual integration branches as described on the wiki).
