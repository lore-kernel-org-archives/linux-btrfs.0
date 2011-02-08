From: Kirk Wolff <kirk@wolffelectronicdesign.com>
Subject: [Fwd: Re: Suggestion for sticky-compression mount setting (default
 mount options)]
Date: Tue, 08 Feb 2011 13:59:13 -0600
Message-ID: <1297195153.16890.2.camel@KWOLFF03>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

forwarded message below:


It would be very iseful.
I also propose the same for `-o ssd` option. USB drive may be used on different computers, and we need the way to specify it only once.
As for the options being per-file, I think having them as per subvolume defaults looks better: we can override the defaults on per-file basis while having reasonable defaults for each subvolume. (There may be also global per-pool defaults, which may be overriden by subvolumes).

-- 
Andrey Korobkov <korobkov@lavabit.com>


