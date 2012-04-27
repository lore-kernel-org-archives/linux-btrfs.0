From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: btrfs-progs: plea for a new release tarball
Date: Thu, 26 Apr 2012 22:31:30 -0700
Message-ID: <CABsxX9+_9eR3_pEhOrwM6YVTPSPsOwRDrPrBqKrFW_wR3vj14A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

I'm one of those few people with several hats on, and one of them is a
packager/distro builder. From that perspective, btrfs-progs is rather
awkward to work with at this time, because as a packager, we like to
work with the tarballs, not git.

And currently, the latest tarball out there is 0.19, and it doesn't
even compile on gcc-4.6 due to -Werror=unused-but-set-variable being
default in that version.

On top of that. 0.19 doesn't contain the 'btrfs' tool. It's... also
rather old already. There's an old kernel.org mirror that has it, and,
it has a 2009 date stamp.

Now, I know I can get it out of git, but, I don't want to. There is
not a single distro (well, realistic one anyway) that pulls all it
sources from git.

So, kindly, I ask you to do a btrfs-progs-0.20 release that includes
the btrfs tool. And post it back at kernel.org/pub/linux/people/mason
? pleeeaaase ?

I'd be ecstatic.

Thanks :)


Auke
