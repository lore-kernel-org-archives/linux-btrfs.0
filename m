From: Josef Bacik <josef@redhat.com>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 09:31:37 -0400
Message-ID: <20111018133137.GB4276@localhost.localdomain>
References: <4E9D7E5A.2010403@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9D7E5A.2010403@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2011 at 09:25:46AM -0400, Jim wrote:
> Good morning btrfs list,
> I have been rsyncing files from an nfs mount to a btrfs filesystem.
> After an rsync run I ls random subvols or directorys to check the
> copy.  About 60% to 70% of the time ls completely hangs.  Ps aux
> shows it as running but even when I let it go for up to an hour it
> never finishes.  Kill -9 will not stop the process.  Dmesg shows
> nothing beyond a successful mount at boot.  I can't umount the
> system because "filesystem is busy".  I find that a forced reboot is
> the only way to recapture the system.  /var/log/messages has the
> only indication (that I can find) that anything abnormal is
> happening.  A tail of the file is below.  Thank you for any help and
> advice.

Hit sysrq+w when this happens and give us all the tracebacks.  Also which kernel
you are on would be helpful.  Thanks,

Josef
