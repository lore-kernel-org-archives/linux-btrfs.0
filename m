From: Lukas Czerner <lczerner@redhat.com>
Subject: System Storage Manager
Date: Wed, 7 Dec 2011 11:20:58 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112071055270.4205@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-lvm@redhat.com,
	linux-btrfs@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I would like to introduce to you a new tool called System Storage
Manager (ssm). It is supposed to provide easy to use command line
interface to manage your storage using various technologies like
lvm, btrfs, encrypted volumes and possibly more.

Background
----------

In more sophisticated enterprise storage environments, management with
Device Mapper (dm), Logical Volume Manager (LVM), or Multiple Devices
(md) is becoming increasingly more difficult. With file systems added
to the mix, the number of tools needed to configure and manage storage
has grown so large that it is simply not user friendly. With so many
options for a system administrator to consider, the opportunity for
errors and problems is large.

The btrfs administration tools have shown us that storage management can
be simplified, and we are working to bring that ease of use to Linux
filesystems in general.


You can also find some more information in my presentation from LinuxCon
Prague this year:

http://people.redhat.com/lczerner/files/lczerner_fsm.pdf


The code is still under development and no release has been made yet, but
I would like to share with you what I have done so far, since the
progress has been a bit slower than I have previously expected. The
project lives on the sf.net :

https://sourceforge.net/projects/storagemanager/

and you can grab source files from git repository here:

https://sourceforge.net/p/storagemanager/code/ci/a1a5fd616d06030f94b9d2e80ee6ebcad09ad35f/tree/

More information can be found on the projects home page, or in the
README file.

https://sourceforge.net/p/storagemanager/home/Home/


Notes
-----

- It is written in python
- So far it supports commands : check, resize, create, list, add, remove
- More commands to come : mirror, snapshot(!)
- It does not support raid yet, except raid 0 from lvm (striped volume)
- It has been tested with python 2.7, but would like to make it work on
  python 2.6 as well.
- It comes with some doctests, unittests and regression tests written in
  bash (although it is for lvm only so far)
- Its "modular" design should make it relatively simple to add support
  for more back-ends other than lvm, or btrfs


Things to be done before the actual release
-------------------------------------------

- Create btrfs bash tests
- Create btrfs unittests
- Extend python unittests to other backends
- Use wipefs -a before using the device in add()
- Consider using wipefs -a after removing the device
- Remove the physical volume after it is removed from the group
- Figure out how to create better pool names so it is unique in the system and
  between the systems.
- Add mirror support
- Add snapshots support
- Add raid support
- use lsblk and blkid to get information
- Better table alignment when the output spans multiple lines
- Better error handling - not just plain Exception, but rather named exception
  and handle it as main() in ssm module
- Update readme
- Add more documentation into the code


Or course any comment or ideas would be highly appreciated. Please
report bugs directly to me.

Thanks!
-Lukas
