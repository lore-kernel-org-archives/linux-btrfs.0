From: btrfs@spiritvideo.com
Subject: revert to static snapshot on reboot
Date: 8 Jan 2012 22:43:04 -0800
Message-ID: <20120109064304.18411.qmail@otpproductions.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all --

I just installed my first btrfs-based linux tonight, and I must say it
gives me a very warm feeling!  Congratulations on all your hard work
and your fine product.

I administer laptops for a small school, and we want to implement what
Deep Freeze (http://www.faronics.com/enterprise/deep-freeze) does for
Windows -- no matter what a student does after they log in, when they
reboot it is all forgotten and the computer has returned to a standard
state.

I would think this would be a FAQ, but I have searched the web and
mailing list for the past couple of hours.

Of course it's easy to mount a snapshot, but then if students make
changes the snapshot changes.

The plan that occurs to me is to make a snapshot of the system in the
state that I want to always boot.  Then, I would rewrite the init
script in the initrd to (a) delete any old tmp copy of the snapshot;
(b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.

That's a little harder than I was hoping to work -- is there an easier
way to get this functionality?

I have a small ext4 boot partition containing grub, vmlinuz and
initramfs.  Everything else is in a big btrfs root partition.  I am
running Fedora 14, with Fedora-patched linux 2.6.35.  I could upgrade
if necessary.

Thanks,
Bob
--
I blog about my work at the school at SmallSchoolIT.wordpress.com
