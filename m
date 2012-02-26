From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: filesystem full when it's not? out of inodes? huh?
Date: Sun, 26 Feb 2012 02:19:06 -0500
Message-ID: <CALJXSJrhyOYoU-g-NOnj=1NfqryaCTZav6mBN-Qc_X2mSpx0qQ@mail.gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org>
	<4F499498.1040006@gmail.com>
	<jicgtv$bg2$1@dough.gmane.org>
	<jiciju$imf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jiciju$imf$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2012 at 1:14 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
>
> # btrfs fi resize 5G /usr; df -h /usr
> Resize '/usr' of '5G'


What would be interesting is getting an eye on btrfs fi df of your
filesystem to see what part is getting full, or maybe just do a
balance.

I have been running 3.0.0 for quite a while without any problem,
metadata grew a bit too much (1.5 TB for 2 TB of data) and balance
fixed it back to 50 GB of metadata then 20 GB after deleting some
snapshots.
