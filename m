From: "Paul Schroeder" <prq@Safe-mail.net>
Subject: How to know whether disks "handle flush requests correctly"
Date: Fri, 6 May 2011 05:13:11 -0400
Message-ID: <N1-HLiSwHA1HL@Safe-mail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs wiki Main Page warns that "it is currently possible to corrupt
a filesystem irrecoverably if your machine crashes or loses power on disks
that don't handle flush requests correctly."

How do you know if this applies to your drives? Is there a way to test it,
or a model list, or are newer SATA drives (magnetic, not SSDs) always ok?
Does it depend on the controller? (I have a SiI 3114, latest BIOS.)

I would also be using btrfs on top of dm-crypt (with the latest release
kernel). Some kernel versions ago, the message that write barriers aren't
supported disappeared; can I assume the device mapper / dm-crypt is not a
problem with regards to flushing?

Paul
