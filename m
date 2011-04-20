From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: GRUB 1.99~rc2 released
Date: Wed, 20 Apr 2011 09:47:23 +0200
Message-ID: <4DAE8F8B.40801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigA00B6E5B5552FE322811B544"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: gnu-prog-discuss@gnu.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA00B6E5B5552FE322811B544
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, all

I'm proud to announce the release of GNU GRUB version 1.99~rc2.

This time we include the ability of GRUB to be firmware on Yeeloong.

This is also the first time we officially include ZFS and BtrFS support.

This is a prerelease. I was able to personaly verify that following
ports are functional: i386-pc, mipsel-yeeloong (including as firwmare),
sparc64-ieee1275, powerpc-ieee1275. Additionaly automated tests were
done with qemu.
However I can't verify everything myself. So please give it a good test,
especially if you have a particular hardware, configuraton or requirement=
s.

The release file is bigger than it should be because of autogeneration
issues. Other than the size these issues have no impact but their fixing
is scheduled for next release.

GRUB, also known as the GRand Unified Bootloader, is a modular, portable
bootloader that supports a number of platforms, including standard
BIOS-based
PCs, IEEE-1275 platforms (such as the OLPC and some PowerPC/Sparc64
hardware), coreboot, the free (as in freedom) pre-boot initialization
framework, and Yeeloong, free (as in freedom)
Loongson-2F-based (MIPS compliant CPU) laptop.

Other major improvements include (extract from NEWS file):

* Keyboard layouts support.

* Parser for GRUB Legacy configuration files.

* Extend `vbeinfo' and `vbetest' commands to non-VBE graphics, as
  `videoinfo' and `videotest'.

* New `lsefisystab', `lssal', and `lsefimmap' commands on EFI platforms.

* Support explicit user claim that a device is BIOS-visible.  Devices
  listed in device.map will be assumed to be readable using only BIOS
  facilities, rather than anything more complex such as LVM or RAID.

* New bash-completion script for GRUB utilities.

* Use ACPI to shut down if possible.

* New `lsacpi' command.

* New `--boot-directory' option to `grub-install', `grub-reboot', and
  `grub-set-default', with clearer semantics than the previous
  `--root-directory' option.

* Rename CD-ROM device to "cd" on BIOS platforms.

* Transparent decompression filters.

* Simpler PXE image generation.  New `grub-mknetdir' utility to generate
  netboot directory trees.

* New relocator.  Allows for more kernel support and more
  straightforward loader writing.

* Handle USB pendrives exposed as floppies.

* New Automake-based build system.

* Add `sendkey' command (i386-pc only).

* Support 1.x versions of mdadm metadata.

* Fix corruption when reading Reiserfs directory entries.

* Bidirectional text and diacritics support.

* Change grub-mkdevicemap to emit /dev/disk/by-id/ names where possible
  on GNU/Linux.

* Add `grub-mkconfig' support for Xen with Linux.

* Add `grub-mkconfig' support for initrd images on Fedora 13.

* Support >3GiB and <16MiB RAM in i386-qemu.

* Add support for Cirrus 5446 and Bochs video cards.

* Load more appropriate video drivers automatically in `grub-mkconfig'.

* USB improvements, including hotplugging/hotunplugging, hub support,
  and USB serial support.

* AMD Geode CS5536 support.

* Extensive updates to the Texinfo documentation.

* Add `grub-probe' support for the btrfs filesystem, permitting / to
  reside on btrfs as long as /boot is on a filesystem natively supported
  by GRUB.

* Handle symbolic links under /dev/mapper on GNU/Linux.

* Handle installation across multiple partition table types.

* Add `cmostest' command (i386/x86_64 only).

* Add support for DM-RAID disk devices on GNU/Linux.

* Remove `grub-mkisofs'.  `grub-mkrescue' now uses GNU xorriso to build
  CD images.

* `grub-mkrescue' support for EFI, coreboot, and QEMU platforms.

* Unify `grub-mkimage', `grub-setup', and `grub-install' source code
  across platforms.

* Fix VGA (as opposed to VBE) video driver, formerly a terminal driver.

* Add menu hotkey support.

* Add support for the nilfs2 filesystem.

* `grub-probe' and `grub-mkconfig' support for NetBSD.

* Support setting a background image in `grub-mkconfig'.

* Support multiple terminals in `grub-mkconfig'.

* Regexp support.

* MIPS multiboot2 support.

* Multiboot2 tag support.

* sunpc partition table support.

* Add a number of new language features to GRUB script: `for', `while',
  `until', `elif', function parameters, `break', `continue', `shift',
  multi-line quoted strings, positional parameters with `setparams',
  `return', filename wildcard expansion, and `!'.

* Support nested partition tables.  GRUB now prefers to name partitions
  in the form `(hd0,msdos1,bsd1)' rather than `(hd0,1,a)'.

* Speed up consecutive hostdisk operations on the same device.


  <http://www.gnu.org/software/grub/>

A source tarball for the new release can be found at:

  http://alpha.gnu.org/gnu/grub/grub-1.99~rc2.tar.gz

and its GPG detached signature [*]:

  http://alpha.gnu.org/gnu/grub/grub-1.99~rc2.tar.gz.sig

[*] You can use either of the above signature files to verify that
the corresponding file (without the .sig suffix) is intact.  First,
be sure to download both the .sig file and the corresponding tarball.
Then, run a command like this:

  gpg --verify grub-1.99~rc2.tar.gz.sig

If that command fails because you don't have the required public key,
then run this command to import it:

  gpg --keyserver keys.gnupg.net --recv-keys E82E4209

and rerun the `gpg --verify' command.

This release was bootstrapped with the following tools:
  Autoconf 2.68
  Automake 1.11.1

GCC 4.4 is the recommended version for building it, although any version
starting with 4.1.3 is supported in this release.

I hope you enjoy using GRUB as much as we enjoyed developing it.

-- Regards Vladimir '=CF=86-coder/phcoder' Serbinenko

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enigA00B6E5B5552FE322811B544
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk2uj4sACgkQNak7dOguQgmUTAD/enrK0tH4CJTAyVC0lgNl0pSk
Vb+qyV975Q9FySpdIVQA/2bQfP19iwZ3izq+5sSKY+tt/hOZkK19t3d/XfXOoUzi
=t8io
-----END PGP SIGNATURE-----

--------------enigA00B6E5B5552FE322811B544--
