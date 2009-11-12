From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck: checksum verify failed
Date: Thu, 12 Nov 2009 09:02:33 -0500
Message-ID: <20091112140233.GB5211@think>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Beregalov wrote:
> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum verify
> failed";echo; done
> checksum verify failed on 31945617408 wanted 6607632D found 9CC3ED0
> checksum verify failed on 31945617408 wanted 6607632D found AFBBF41

Was your filesystem mounted at the time?  It's strange that the checksum
keeps changing, that points to the data in the block changing.

-chris
