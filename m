Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3AUKuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 05:50:37 -0500
Date: Mon, 21 Jan 2013 11:50:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        josef@toxicpanda.com
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Message-ID: <20130121105034.GD19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F9B851.1020908@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50F9B851.1020908@czarc.net>

On Fri, Jan 18, 2013 at 04:02:09PM -0500, Gene Czarcinski wrote:
> >Please send them to the list.
> >
> Josef Bacik <josef@toxicpanda.com> is the current Fedora maintainer as
> indicated in bugzilla.
> <mailto:josef@toxicpanda.com>
> Currently in Fedora 18, btrfs-progs is the "v0.20-rc1 with git commit id
> <mailto:josef@toxicpanda.com>91d9eec" plus a total of seven patches.  Two of
> those patches from the list which I have already indicated.  The rest of
> those patches have been around for a while (at least since mid 2011) and I
> cannot find any doc.
> 
> While I could send them in (and will if needed), I feel a little uneasy
> since Josef is responsible in Fedora.  While this may be a different
> individual since the email address is different, I suspect this Josef is the
> same Josef who wrote the other two patches and he may be able to speak to
> them better.

Sorry, I somehow assumed you were speaking on behalf of Fedora.

> I have been scraping mailing list for all of the btrfs-progs patches and
> plan to gradually test them.  Since it appears you will be doing something
> similar, if you want to point me to some for testing, I will give it a shot
> with some virtual and some real-iron testing.  And sometimes it is also a
> matter of the time needed to refit/rebase patches.

Great, thanks! Testing of the userspace utilities is relatively safe
(compared to the kernel module) and I'm using using the tool compiled
from the master+patches on my regular testboxes. So far no disasterous
problems encountered and I can immediatelly see if something goes wrong
during normal use of the tools.

Hugo once started a regression testsuite that should eg. verify sanity
of the option parsing, so extending these tests would be welcome.

http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-progs-unstable.git;a=commit;h=c18d54a5bab5f5e0c6dc3c8cf4a1cc073e82f876


david
