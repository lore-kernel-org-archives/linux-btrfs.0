From: Chris Ball <cjb@laptop.org>
Subject: Re: kernel BUG
Date: Thu, 23 Dec 2010 19:19:32 -0500
Message-ID: <m3d3os3tuz.fsf@pullcord.laptop.org>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org> <20101223215500.4f177913@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101223215500.4f177913@simplux> (Michael Niederle's message of
	"Thu, 23 Dec 2010 21:55:00 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Michael,

   >> in write_all_supers().  Does dmesg say anything about the nature
   >> of the errors above the BUG() line?

   > The message was output to the console of the crashed system - so
   > I'm sorry I cannot supply further informations.

Ah, okay.  You could consider installing kgdb/kdb -- it will let you
drop to the kdb shell after the crash and run dmesg through a pager.

Just:

CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y

and then boot with "kgdboc=kms,kbd" added.

   > But exactly the same crash happened again some minutes ago. (I'm
   > now back to my old kernel.)

Not sure I understand.  Do you mean that the same crash happens on
your older kernel now, or that you've reverted to your older kernel
because you had another -rc5 crash?  If the crash happens on -rc5 but
not the older kernel (what revision is the older kernel?), that's
extremely interesting.

Josef/Chris, any knowledge about hitting this BUG() on -rc5?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
