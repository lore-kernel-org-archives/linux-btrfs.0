From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Fri, 10 Feb 2012 14:45:43 -0500
Message-ID: <4F3573E7.9080306@ubuntu.com>
References: <pan.2012.01.26.15.41.32@cox.net> <201201291223.40161.kreijack@inwind.it> <COL113-W485767962008EF29E7E27EB08D0@phx.gbl> <pan.2012.01.31.05.55.47@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.31.05.55.47@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/31/2012 12:55 AM, Duncan wrote:
> Thanks!  I'm on grub2 as well.  It's is still masked on gentoo, but
> I recently unmasked and upgraded to it, taking advantage of the
> fact that I have two two-spindle md/raid-1s for /boot and its
> backup to test and upgrade one of them first, then the other only
> when I was satisfied with the results on the first set.  I'll be
> using a similar strategy for the btrfs upgrades, only most of my
> md/raid-1s are 4-spindle, with two sets, working and backup, and
> I'll upgrade one set first.

Why do you want to have a separate /boot partition?  Unless you can't
boot without it, having one just makes things more
complex/problematic.  If you do have one, I agree that it is best to
keep it ext4 not btrfs.

> Meanwhile, you're right about subvolumes.  I'd not try them on a
> btrfs /boot, either.  (I don't really see the use case for it, for
> a separate /boot, tho there's certainly a case for a /boot
> subvolume on a btrfs root, for people doing that.)

The Ubuntu installer creates two subvolumes by default when you
install on btrfs: one named @, mounted on /, and one named @home,
mounted on /home.  Grub2 handles this well since the subvols have
names in the default root, so grub just refers to /@/boot instead of
/boot, and so on.  The apt-btrfs-snapshot package makes apt
automatically snapshot the root subvol so you can revert after an
upgrade.  This seamlessly causes grub to go back to the old boot menu
without the new kernels too, since it goes back to reading the old
grub.cfg in the reverted root subvol.

I have a radically different suggestion you might consider rebuilding
your system using.  Partition each disk into only two partitions: one
for bios_grub, and one for everything else ( or just use MBR and skip
the bios_grub partition ).  Give the second partitions to mdadm to
make a raid10 array out of.  If you use a 2x far and 2x offset instead
of the default near layout, you will have an array that can still
handle any 2 of the 4 drives failing, will have twice the capacity of
a 4 way mirror, almost the same sequential read throughput of a 4 way
raid0, and about twice the write throughput of a 4 way mirror.
Partition that array up and put your filesystems on it.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPNXPnAAoJEJrBOlT6nu75/d8IAJ0fQ3xWPe6SYBY8nj34mcWh
ql6C4ieMkd07ZCuymT5ZVhWJhtdc6/Vg7ecWmhYdeu4d1WGp4DvTumEYHVl4ZlRk
mT9Lq4SupDL5Dk0nfxZUqY8XnIek3kIG/wgekgdSuLF0J9QFQdCFc25j/idIh0Dy
Gk5NJtgKmsTKUQhzPQZxif8nwWVQzQICm5P//FeOQgx8sq7iVdCQHUxlJEPfsL7m
CVVMJPVk+524rFTWxLZ4KLbXkNE7nrikg7UMlWBtM5gflkU0Y+bfmZKPGcqBCSSn
AId5M5alzjLSLblBqwf8wKpEIiDXBqb6f+bSxqnk5FdKKx5l5lziZyqQM+gnyIo=
=ePD3
-----END PGP SIGNATURE-----
