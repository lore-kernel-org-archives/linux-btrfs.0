From: David Sterba <dave@jikos.cz>
Subject: Re: Problems with tuxonice and btrfs
Date: Wed, 7 Sep 2011 14:39:17 +0200
Message-ID: <20110907123917.GC22205@twin.jikos.cz>
References: <1315149806.23766.2.camel@picard>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315149806.23766.2.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 04, 2011 at 04:23:20PM +0100, Maciej Marcin Piechotka wrote:
> I get filesystem corruption when I unsuccessfully hibernate using
> tuxonice. I don't get this problem using standard suspend.

Just a guess and general thought, I've never used TOI. There is probably
some activity inside the filesystem going on and is not properly
stopped, like in the standard suspend case. I'd start at TOI verifying
that it follows the steps during freezing and unfreezing the filesystem,
as does standard suspend.

> While I understand TOI is not in mainline it requires no modification
> for non-FUSE filesystems. where should I report the problem?

This does not seem to be a genuine btrfs bug, rather some misinteraction
with TOI.


david
