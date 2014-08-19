Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:58136 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaHSWK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 18:10:56 -0400
Date: Tue, 19 Aug 2014 15:10:55 -0700
From: Zach Brown <zab@zabbo.net>
To: Klaus Holler <kho@gmx.at>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0 and
 btrfs-progs 3.14.2
Message-ID: <20140819221055.GI429@lenny.home.zabbo.net>
References: <53F0A3B2.80709@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F0A3B2.80709@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 17, 2014 at 02:44:34PM +0200, Klaus Holler wrote:
> Hello list,
> 
> I want to use an ARM kirkwood based NSA325v2 NAS (dubbed "Receiver") for
> receiving btrfs snapshots done on several hosts, e.g. a Core Duo laptop
> running kubuntu 14.04 LTS (dubbed "Source"), storing them on a 3TB WD
> red disk (having GPT label, partitions created with parted).
> 
> But all the btrfs receive commands on 'Receiver' fail soon with e.g.:
>   ERROR: writing to initrd.img-3.13.0-24-generic.original failed. File
> too large
> ... and that stops reception/snapshot creation.

...

> Increasing the verbosity with "-v -v" for btrfs receive shows the
> following differences between receive operations on 'Receiver' and
> 'OtherHost', both of them using the identical inputfile
> /boot/.snapshot/20140816-1310-boot_kernel3.16.0.btrfs-send
> 
> * the chown and chmod operations are different -> resulting in
> weird/wrong permissions and sizes on 'Receiver' side.
> * what's "stransid", this is the first line that differs

This is interesting, thanks for going to the trouble to show those
diffs.

That the commands and strings match up show us that the basic tlv header
chaining is working.  But the u64 attribute values are sometimes messed
up.  And messed up in a specific way.  A variable number of low order
bytes are magically appearing.

(gdb) print/x 11709972488
$2 = 0x2b9f80008
(gdb) print/x 178680
$3 = 0x2b9f8

(gdb) print/x 588032
$6 = 0x8f900
(gdb) print/x 2297
$7 = 0x8f9

Some light googling makes me think that the Marvell Kirkwood is not
friendly at all to unaligned accesses.

The (biting tongue) send and receive code is playing some games with
casting aligned and unaligned pointers.  Maybe that's upsetting the arm
toolchain/kirkwood.  Does this completely untested patch to btrfs-progs,
to be run on the receiver, do anything?

- z

diff --git a/send-stream.c b/send-stream.c
index 88e18e2..4f8dd83 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -204,7 +204,7 @@ out:
                int __len; \
                TLV_GET(s, attr, (void**)&__tmp, &__len); \
                TLV_CHECK_LEN(sizeof(*__tmp), __len); \
-               *v = le##bits##_to_cpu(*__tmp); \
+               *v = get_unaligned_le##bits(__tmp); \
        } while (0)
 
 #define TLV_GET_U8(s, attr, v) TLV_GET_INT(s, attr, 8, v)
