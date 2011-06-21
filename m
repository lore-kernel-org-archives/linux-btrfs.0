From: Sander <sander@humilis.net>
Subject: Re: Abysmal Performance
Date: Tue, 21 Jun 2011 10:00:59 +0200
Message-ID: <20110621080058.GA29265@attic.humilis.net>
References: <7da312412980843ba746e4e8809060f8@localhost>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Henning Rohlfs <x+btrfs@xehonk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7da312412980843ba746e4e8809060f8@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

Henning Rohlfs wrote (ao):
> - space_cache was enabled, but it seemed to make the problem worse.
> It's no longer in the mount options.

space_cache is a one time mount option which enabled space_cache. Not
supplying it anymore as a mount option has no effect (dmesg | grep btrfs).

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
