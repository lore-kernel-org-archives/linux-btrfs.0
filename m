From: Jan Engelhardt <jengelh@medozas.de>
Subject: Wrong error message when using unknown 2nd subcommand
Date: Fri, 24 Feb 2012 06:48:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202240647260.12486@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


In btrfsprogs-0.19, using an unknown second argument (fd, misspelled) 
leads to an error message complaining about the first argument (it 
should report the second one instead).

$ btrfs fi df
ERROR: 'filesystem df' requires 1 arg(s)
$ btrfs fi fd
ERROR: unknown command 'fi'
