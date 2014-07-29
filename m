Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc4s4.hotmail.com ([65.54.190.206]:57402 "EHLO
	BAY004-OMC4S4.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG2SuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 14:50:01 -0400
Message-ID: <BAY172-W396EC3E14A0DC50B6BC3EFB0F80@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
Date: Tue, 29 Jul 2014 13:50:00 -0500
In-Reply-To: <53D70469.1030504@jp.fujitsu.com>
References: <53D1F661.1030504@jp.fujitsu.com>
 <BAY172-W33CE4C937687878CDD0C23B0FB0@phx.gbl>,<53D70469.1030504@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----------------------------------------
> Date: Tue, 29 Jul 2014 11:18:17 +0900
> From: takeuchi_satoru@jp.fujitsu.com
> To: kylegates@hotmail.com; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
>
> Hi Kyle,
>
> (2014/07/28 22:24), Kyle Gates wrote:
>>
>> small wording error inline below
>>
>> ----------------------------------------
>>> Date: Fri, 25 Jul 2014 15:17:05 +0900
>>> From: takeuchi_satoru@jp.fujitsu.com
>>> To: linux-btrfs@vger.kernel.org
>>> Subject: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
>>>
>>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>>
>>> - There are many format to show snapshot name in error messages,
>>> "'%s'", "'%s", "%s", "('%s')", and "('%s)". Since it's messy,
>>> unify these to "'%s'" format.
>>> - Fix a type: s/uncorrect/incorrect/
>>>
>>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>>
>>> ---
>>> cmds-subvolume.c | 16 ++++++++--------
>>> 1 file changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>> index b7bfb3e..ce38503 100644
>>> --- a/cmds-subvolume.c
>>> +++ b/cmds-subvolume.c
>>> @@ -140,14 +140,14 @@ static int cmd_subvol_create(int argc, char **argv)
>>> dstdir = dirname(dupdir);
>>>
>>> if (!test_issubvolname(newname)) {
>>> - fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
>>> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>>> newname);
>>> goto out;
>>> }
>>>
>>> len = strlen(newname);
>>> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
>>> - fprintf(stderr, "ERROR: subvolume name('%s)\n",
>>> + fprintf(stderr, "ERROR: subvolume name too long '%s'\n",
>>> newname);
>>> goto out;
>>> }
>>> @@ -314,7 +314,7 @@ again:
>>> free(cpath);
>>>
>>> if (!test_issubvolname(vname)) {
>>> - fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
>>> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>>> vname);
>>> ret = 1;
>>> goto out;
>>> @@ -322,7 +322,7 @@ again:
>>>
>>> len = strlen(vname);
>>> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
>>> - fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
>>> + fprintf(stderr, "ERROR: too long snapshot name '%s'\n",
>>
>> + fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
>
> Thank you for your comment. Fixed. How about is it?

Yes, that looks good. Thanks.
>
> ===
> From 73f9847c603fbe863f072d029b1a4948a1032d6e Mon Sep 17 00:00:00 2001
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Date: Fri, 25 Jul 2014 12:46:27 +0900
> Subject: [PATCH] btrfs-progs: unify the format of error messages.
>
> ---
> cmds-subvolume.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index b7bfb3e..5a99c94 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -140,14 +140,14 @@ static int cmd_subvol_create(int argc, char **argv)
> dstdir = dirname(dupdir);
>
> if (!test_issubvolname(newname)) {
> - fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
> newname);
> goto out;
> }
>
> len = strlen(newname);
> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
> - fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
> + fprintf(stderr, "ERROR: subvolume name too long '%s'\n",
> newname);
> goto out;
> }
> @@ -314,7 +314,7 @@ again:
> free(cpath);
>
> if (!test_issubvolname(vname)) {
> - fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
> vname);
> ret = 1;
> goto out;
> @@ -322,7 +322,7 @@ again:
>
> len = strlen(vname);
> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
> - fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
> + fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
> vname);
> ret = 1;
> goto out;
> @@ -722,14 +722,14 @@ static int cmd_snapshot(int argc, char **argv)
> }
>
> if (!test_issubvolname(newname)) {
> - fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
> + fprintf(stderr, "ERROR: incorrect snapshot name '%s'\n",
> newname);
> goto out;
> }
>
> len = strlen(newname);
> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
> - fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
> + fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
> newname);
> goto out;
> }
> @@ -778,7 +778,7 @@ static int cmd_snapshot(int argc, char **argv)
> res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
>
> if (res < 0) {
> - fprintf( stderr, "ERROR: cannot snapshot %s - %s\n",
> + fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
> subvol_descr, strerror(errno));
> goto out;
> }
> @@ -991,7 +991,7 @@ static int cmd_subvol_show(int argc, char **argv)
>
> ret = find_mount_root(fullpath, &mnt);
> if (ret < 0) {
> - fprintf(stderr, "ERROR: find_mount_root failed on %s: "
> + fprintf(stderr, "ERROR: find_mount_root failed on '%s': "
> "%s\n", fullpath, strerror(-ret));
> goto out;
> }
> --
> 1.9.3
>
 		 	   		  