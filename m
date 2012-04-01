From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 1 Apr 2012 11:42:23 -0400
Message-ID: <CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
References: <20120401152749.61790@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Norbert Scheibner <scno@gmx.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120401152749.61790@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 1, 2012 at 11:27 AM, Norbert Scheibner <scno@gmx.net> wrote:
> Some users tested this patch successfully for week,s or months in 2 or 3 kernel versions since then, true?

If this feature must be implented in VFS in another patch, why not
just activate what works and make the future patch disable it again?
