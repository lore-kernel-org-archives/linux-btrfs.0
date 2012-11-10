Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hosting.adsl24.co.uk ([84.234.17.171]:58418 "EHLO
	hosting.adsl24.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2KJJoR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 04:44:17 -0500
Received: from ty-penguin.org.uk ([109.224.128.212]:42545 helo=opus.ty-penguin.org.uk)
	by hosting.adsl24.co.uk with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <alun.btrfs@ty-penguin.org.uk>)
	id 1TX6Sc-0000uF-HI
	for linux-btrfs@vger.kernel.org; Sat, 10 Nov 2012 08:30:38 +0000
Received: from ap.ty-penguin.org.uk ([10.0.0.253] helo=aspire.ty-penguin.org.uk)
	by opus.ty-penguin.org.uk with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <alun.btrfs@ty-penguin.org.uk>)
	id 1TX6Sa-0001IF-TZ
	for linux-btrfs@vger.kernel.org; Sat, 10 Nov 2012 08:30:36 +0000
Date: Sat, 10 Nov 2012 08:31:11 +0000
From: Alun <alun.btrfs@ty-penguin.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Bug in a couple of btrfs-progs components
Message-ID: <20121110083111.25d3fcef@aspire.ty-penguin.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dhTynNhf+8QgPzLCumUylBX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/dhTynNhf+8QgPzLCumUylBX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

(I'm not a list member and may not see any responses to this)

I've been using btrfs on my Raspberry Pi. Yesterday I tried to use the
"btrfs scrub" function and, while the scrub started OK, I couldn't run
"btrfs scrub status" to see what was happening. Whenever I ran it, I
just got the command help.

The same command on my x86 box worked OK. Checking out the git sources,
I found that, in a couple of places, "char c" is used to store the
return value from getopt. On the Pi, char is unsigned, so the
subsequent test for getopt returning -1 never succeeds.

I'm attaching a patch to fix this.

Cheers,
Alun.

--MP_/dhTynNhf+8QgPzLCumUylBX
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=btrfs-progs.patch

diff --recursive '--context=5' btrfs-progs.orig/cmds-scrub.c btrfs-progs/cmds-scrub.c
*** btrfs-progs.orig/cmds-scrub.c	Sat Nov 10 08:24:33 2012
--- btrfs-progs/cmds-scrub.c	Sat Nov 10 08:24:52 2012
***************
*** 1602,1612 ****
  	};
  	int ret;
  	int i;
  	int print_raw = 0;
  	int do_stats_per_dev = 0;
! 	char c;
  	char fsid[37];
  	int fdres = -1;
  	int err = 0;
  
  	optind = 1;
--- 1602,1612 ----
  	};
  	int ret;
  	int i;
  	int print_raw = 0;
  	int do_stats_per_dev = 0;
! 	int c;
  	char fsid[37];
  	int fdres = -1;
  	int err = 0;
  
  	optind = 1;
diff --recursive '--context=5' btrfs-progs.orig/cmds-send.c btrfs-progs/cmds-send.c
*** btrfs-progs.orig/cmds-send.c	Sat Nov 10 08:24:33 2012
--- btrfs-progs/cmds-send.c	Sat Nov 10 08:24:43 2012
***************
*** 412,422 ****
  }
  
  int cmd_send_start(int argc, char **argv)
  {
  	char *subvol = NULL;
! 	char c;
  	int ret;
  	char *outname = NULL;
  	struct btrfs_send send;
  	u32 i;
  	char *mount_root = NULL;
--- 412,422 ----
  }
  
  int cmd_send_start(int argc, char **argv)
  {
  	char *subvol = NULL;
! 	int c;
  	int ret;
  	char *outname = NULL;
  	struct btrfs_send send;
  	u32 i;
  	char *mount_root = NULL;

--MP_/dhTynNhf+8QgPzLCumUylBX--
