Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49271 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2JYPNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:13:30 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so664226eek.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 08:13:28 -0700 (PDT)
Message-ID: <1351178178.1923.12.camel@hughsie-work.lan>
Subject: Re: Naming of subvolumes
From: Richard Hughes <hughsient@gmail.com>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Date: Thu, 25 Oct 2012 16:16:18 +0100
In-Reply-To: <CAAeznTr6AvqbJ+WOw6S5kyW2_qbSUQgJfAO88m9KdV+3PyGUcw@mail.gmail.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	 <20121025132825.GD25498@carfax.org.uk>
	 <1351172653.1923.10.camel@hughsie-work.lan>
	 <CAAeznTr6AvqbJ+WOw6S5kyW2_qbSUQgJfAO88m9KdV+3PyGUcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2012-10-25 at 16:09 +0100, Leonidas Spyropoulos wrote:
> On another note. How would you implement that logic (make a snapshot
> before upgrade) without the lib? Would you wrap package manager into a
> wrapper or patch package manager to call snapshot and the upgrade.
> In both cases you will need to parse stdout, stderr from the snapshot
> creation.

I'm intending to add the snapshot stuff in the logic described here:
https://gitorious.org/packagekit/packagekit/blobs/master/contrib/systemd-updates/README.txt

> Also would you automatically roll back to before snapshot if something
> goes wrong or give option to user? Can you categorise errors on
> upgrades according ti fatality to the system?

If *anything* in the upgrade fails and we've already started the package
transaction then we'd roll back to the previous known-good snapshot.

Richard.

