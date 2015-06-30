Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbbF3NJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 09:09:41 -0400
Date: Tue, 30 Jun 2015 15:09:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Amr El-Sharnoby <amr.elsharnoby@horizontechs.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs 4.1 failed to compile on CentOS 6.x
Message-ID: <20150630130939.GG726@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAGMys1p9=p-22mfSMCtMXgrmA=1mOs0mzRBTDmt_67q8D4OJEw@mail.gmail.com>
 <20150630124052.GF726@twin.jikos.cz>
 <CAGMys1q-u=3bvp7REnzvEa0zsPk_VgNDruwWqHHJ5G2a2pnuow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGMys1q-u=3bvp7REnzvEa0zsPk_VgNDruwWqHHJ5G2a2pnuow@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 03:43:49PM +0300, Amr El-Sharnoby wrote:
> rpm -q gcc
> gcc-4.4.7-11.el6.x86_64
> 
> It's the latest available.

Ok, I'll drop the optional argument. Fixed in git and will be released
in 4.1.1.
