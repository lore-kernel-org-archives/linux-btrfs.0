From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: revert to static snapshot on reboot
Date: Mon, 09 Jan 2012 19:43:35 +0100
Message-ID: <k3prt8-n92.ln1@hurikhan.ath.cx>
References: <20120109064304.18411.qmail@otpproductions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

btrfs@spiritvideo.com <btrfs@spiritvideo.com> schrieb:

> The plan that occurs to me is to make a snapshot of the system in the
> state that I want to always boot.  Then, I would rewrite the init
> script in the initrd to (a) delete any old tmp copy of the snapshot;
> (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.

I'd suggest to create a snapshot during initrd phase, then switch to that 
snapshot as the root. Before creating the new snapshot, first delete all old 
snapshots still there... Something like:

# sda1 = btrfs
mkdir -p /btrfs-prepare
mount /dev/sda1 /btrfs-prepare -o $REAL_ROOT_FLAGS,...
for snapshot in /btrfs-prepare/snapshots/*; do
  btrfs sub del "$snapshot"
done
snapshot="snapshots/root-$(date +%s)"
# original-root has to be a subvolume
btrfs sub snap /btrfs-prepare/original-root /btrfs-prepare/"$snapshot"
REAL_ROOT="$snapshot"
sync
umount /btrfs-prepare
# now let the rest of the initrd switch to the real root
# depending on your initrd system REAL_ROOT needs to be named
# differently: it should result in mount options like
# -o subvol=snapshots/root-123456789,...

This should be much faster than copying stuff around. I'm not sure how btrfs 
behaves when unmounting during the btrfs-cleaner deleting snapshots. It may 
become instable over time. I'm sure the btrfs gurus here can comment on 
this. I used a timestamp on the snapshot names so no naming conflicts occur 
during snapshot deletion and creation. I figured that if deleting and 
recreating the same snapshot name may confuse btrfs after unexpected reboots 
while the btrfs-cleaner was still running.

The above script expects your btrfs layout to be something like that:

$ ls -al /
./
original-root/ # system installation goes here (subvolume)
snapshots/     # normal empty directory
# nothing more

This way you can also use an alternate initrd which does no snapshotting to 
upgrade or reconfigure the system. Or you just chroot into the original root 
and update that.

HTH
Kai

