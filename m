From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Question on subvolumes and mount options
Date: Sun, 13 Feb 2011 17:46:46 +0100
Message-ID: <87oc6fj30p.fsf@savara.sat.thregr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone, I'm experimenting with btrfs but I have some question
regarding subvolumes.

First: In the / filesystem I create a subvolume named /home. As soon as
the subvolume is created, I can already see the entry point in /home
without having to mount it separately. Is that expected?

Mounting the subvolume with mount -o subvol=home /dev/x /home also works
as expected.

So, which is best? Looks like mounting subvolumes is not necessary.

Is it possible to change mount options in a subvolume? Suppose I would
like to use nodatasum except for /home, will the following work?

mount -o nodatasum /dev/x /
btrfs subvolume create /home
mount -o datasum,subvol=home /dev/x

Thanks for any clarification.

