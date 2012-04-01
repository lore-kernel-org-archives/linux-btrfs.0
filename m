From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 18:41:36 +0200
Message-ID: <20120401164136.61800@gmx.net>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F787485.202@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On: Sun, 01 Apr 2012 18:30:13 +0300 Konstantinos Skarlatos wrote

> +1 from me too, i would save enormous amounts of space with a patch 
> like that, at least until dedupe is implemented. We could call it "poor 
> man's dedupe"

That's my point. This poor man's dedupe would solve my problems here very well. I don't need a zfs-variant of dedupe. I can implement such a file-based dedupe with userland tools and would be happy.

It's there, it's tested, it doesn't break another thing. Use it!

Greetings
   Norbert

