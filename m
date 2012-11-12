Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:53202 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2KLSaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 13:30:20 -0500
Date: Mon, 12 Nov 2012 19:30:19 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Alfredo Esteban <aedelatorre@gmail.com>
cc: cwillu <cwillu@cwillu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-convert: show progress
In-Reply-To: <CAKZ=RP8KpCBUL=Q51rTp7WEPuqiXnxBXjXkjDLTCZgdMeHEumw@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1211121926590.1611@nerf07.vanv.qr>
References: <CAKZ=RP8V7J=vYerLGzavq5GBFmNtmyRYeautEoAyWqOud9b3Pw@mail.gmail.com> <CAE5mzvj-rOzVfuhUsNjd5=GyZrN4W-gGJ-yqdSJFemAyC=8e=w@mail.gmail.com> <CAKZ=RP8KpCBUL=Q51rTp7WEPuqiXnxBXjXkjDLTCZgdMeHEumw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Saturday 2012-09-29 03:08, Alfredo Esteban wrote:

>+	__u32 progressunit;
>+	__u32 halfprogunit;
>+	__u32 progressperc;
>+	int istty;
>+	int progress;
>+	int flagprint;
>+	float perc;
>+	char msg[128];
>+	char bar[256];
>+} progress_bar;

>+	sprintf(pb->msg, "Creating btrfs metadata");
>+	
>+	if (isatty(fileno(stdout)) != 0)
>+		pb->istty = 1;
>+	else
>+		pb->istty = 0;

	pb->istty = isatty(fileno(stdout));

>+	pb->inoinuse = ext2_fs->super->s_inodes_count
>+		- ext2_fs->super->s_free_inodes_count;
>+	pb->inocopied = 0;
>+	pb->progressunit = pb->inoinuse / PROGRESS_BAR_LENGTH;
>+	pb->halfprogunit = (int)(pb->progressunit/2);

	Pointless cast.

>+	pb->progressperc = pb->inoinuse / 100;
>+	pb->progress = 0;
>+	pb->flagprint = 0;
>+	pb->perc = 0;
>+	pb->bar[0] = '[';
>+	for (i = 1; i < PROGRESS_BAR_LENGTH+1; i++) pb->bar[i] = ' ';
>+	pb->bar[PROGRESS_BAR_LENGTH+1] = ']';
>+	pb->bar[PROGRESS_BAR_LENGTH+2] = '\0';
>+	if (pb->istty) {
>+		printf("\e[?25l"); // hide the cursor

I would not go to the hassle of hiding the cursor, because then you
would also have to handle SIGINT and restore the cursor there.
Just leave the cursor as-is, like everybody else.

