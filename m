From: David Nicol <davidnicol@gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: btrfs: implement async option for
 snapshot command
Date: Mon, 1 Nov 2010 13:51:59 -0500
Message-ID: <AANLkTi=to2vd65nfz_G4awQ3=KS0HmesaSjt36bZsK6U@mail.gmail.com>
References: <1288629262-5405-1-git-send-email-sage@newdream.net> <1288629262-5405-3-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288629262-5405-3-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

this would be yet another thing that ioctl#21 could have a flag to wait for.

On Mon, Nov 1, 2010 at 11:34 AM, Sage Weil <sage@newdream.net> wrote:
> Add an 'async' option to the snapshot creating command, that will let you
> avoid waiting for a new snapshot to commit to disk.
>
> Signed-off-by: Sage Weil <sage@newdream.net>
