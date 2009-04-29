From: nightrow <nightrow@gmail.com>
Subject: Re: BUG: btrfsck segfaults on regular file
Date: Wed, 29 Apr 2009 21:19:56 +0000 (UTC)
Message-ID: <loom.20090429T211105-898@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I just tried running btrsfck without enough right to open the device, i got the
same : a segfault. I also got the segfault taking a unknow device.

Please display a message like : "Unknow device or file, you may not have enough
rights to open it"

