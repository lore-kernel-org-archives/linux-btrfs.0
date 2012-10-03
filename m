Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52744 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JCRUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:20:13 -0400
Received: by eekb15 with SMTP id b15so4212831eek.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 10:20:11 -0700 (PDT)
Date: Wed, 3 Oct 2012 20:20:08 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
Message-ID: <20121003172007.GA2890@zambezi.lan>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
 <1349264596-9383-2-git-send-email-kreijack@inwind.it>
 <20121003150219.GB1978@zambezi.lan>
 <506C691E.6020506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506C691E.6020506@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 06:34:38PM +0200, Goffredo Baroncelli wrote:
> On 10/03/2012 05:02 PM, Ilya Dryomov wrote:
> >On Wed, Oct 03, 2012 at 01:43:15PM +0200, Goffredo Baroncelli wrote:
> >>The  command  btrfs  filesystem  df is used to query the
> >>status of the chunks, how many space on the disk(s) are used  by
> >>the  chunks,  how many space are available in the chunks, and an
> >>estimation of the free space of the filesystem.
> >>---
> >>  cmds-filesystem.c |  264 +++++++++++++++++++++++++++++++++++++++++++----------
> >>  1 file changed, 215 insertions(+), 49 deletions(-)
> >>
> >>diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> >>index b1457de..6c3ebdc 100644
> >>--- a/cmds-filesystem.c
> >>+++ b/cmds-filesystem.c
> >
> >(snipped)
> >
> >>+static int cmd_disk_free(int argc, char **argv)
> >>+{
> >>+
> >>+	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
> >>+	int	i, more_than_one=0;
> >>+
> >>+	if (check_argc_min(argc, 2))
> >>+		usage(cmd_disk_free_usage);
> >>+
> >>+	for(i=1; i<  argc ; i++){
> >>+		if(!strcmp(argv[i],"-d"))
> >>+			flags&= ~DF_SHOW_DETAIL;
> >>+		else if(!strcmp(argv[i],"-s"))
> >>+			flags&= ~DF_SHOW_SUMMARY;
> >>+		else if(!strcmp(argv[i],"-k"))
> >>+			flags&= ~DF_HUMAN_UNIT;
> >>+		else{
> >>+			int r;
> >>+			if(more_than_one)
> >>+				printf("\n");
> >>+			r = _cmd_disk_free(argv[i], flags);
> >>+			if( r ) return r;
> >>+			more_than_one=1;
> >>+		}
> >
> >Is there any reason getopt(), or better yet, getopt_long() won't work?
> 
> In the beginning there were also the switches +d, +s, +k, then I
> dropped them. So I leaved this style. The code is simple enough to
> not justify a change.

It's not a matter of style.  It is generally expected that several short
options can be specified after one dash.  Further, if somebody else were
to add an option with an optional parameter, they'd have to spend time
rewriting your stuff.

In addition to that, other parts of progs already use getopt() in
similar situations.  One example would be the scrub subgroup: scrub
commands are equally simple (a few short switches, no parameters), and
yet getopt() is used.

> 
> >
> >>+
> >>+	}
> >>+
> >>+	return 0;
> >>+}	
> >>+	
> >>+
> >>+	
> >>  static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
> >>  {
> >>  	char uuidbuf[37];
> >>@@ -529,7 +695,7 @@ static int cmd_label(int argc, char **argv)
> >>
> >>  const struct cmd_group filesystem_cmd_group = {
> >>  	filesystem_cmd_group_usage, NULL, {
> >>-		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
> >>+		{ "df", cmd_disk_free, cmd_disk_free_usage, NULL, 0 },
> >
> >If this command is going to replace df, you should change the function
> >name back to cmd_df.
> 
> I was never convinced to use 'df'. At the beginning when I wrote the
> first parser of btrfs, was suggested (not by me) to use "long"
> command and allow the parser to match a contracted command until
> there was any ambiguity. I suggested to use disk-free, but everybody
> were confortable with df.. so I leaved it as "official name". But I
> prefer for the internal code a more verbose name.

Well, all your patch is doing is extending the functionality of an
existing command.  The "official name" for that command is "df", and you
are not changing its name.  Why change the name of an existing function?

Thanks,

		Ilya
