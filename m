From: Calvin Morrow <calvin.morrow@gmail.com>
Subject: Large metadata mount messages lost after reboot
Date: Mon, 9 Apr 2012 16:06:56 -0600
Message-ID: <CADxhoDTqCuvtiAUd5a4AAZsLBQ=7i-mvf8X0FeZB1CyBJXpdyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

I am testing the 3.4.0(rc) btrfs patches backported to a 3.3.1 kernel.
 I'm particularly interested in the large metadata features for help
with fragmentation issues.  After merging, installing, and booting the
new kernel, I created several btrfs filesystems with leaf size 32768
and node size 32768.

Mounting the filesystem gives the expected behavior with the following
messages in syslog:

Apr  9 14:56:18 app-cluster1 kernel: [ 1872.279286] device fsid
48be2eaf-f2af-444a-a440-ae0ed555f1e7 devid 1 transid 7 /dev/sdd
Apr  9 14:56:18 app-cluster1 kernel: [ 1872.281352] btrfs flagging fs
with big metadata feature

After a reboot however, the "flagging fs with big metadata feature"
message no longer appears on subsequent mounts.

Apr  9 15:03:28 app-cluster1 kernel: [   12.083827] device fsid
48be2eaf-f2af-444a-a440-ae0ed555f1e7 devid 1 transid 11 /dev/sdd
Apr  9 15:03:28 app-cluster1 kernel: [   12.118204] device fsid
078b5f99-89ba-4e46-9ed9-26895d188a3e devid 1 transid 11 /dev/sde
Apr  9 15:03:28 app-cluster1 kernel: [   12.136635] device fsid
ca2fd449-d582-4d46-ab9a-c89c17762f8d devid 1 transid 11 /dev/sdf

I've verified I'm rebooting into the correct kernel:  Linux
app-cluster1 3.3.1.app.btrfs-backports #1 SMP Sun Apr 8 19:33:29 MDT
2012 x86_64 x86_64 x86_64 GNU/Linux

Is this expected behavior?  Is there a way I can dump filesystem
information to determine what leaf and node size the filesystem thinks
it has?

Calvin
