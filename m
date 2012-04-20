From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH 3/4] avoid strncpy-induced buffer overrun
Date: Fri, 20 Apr 2012 21:26:58 +0200
Message-ID: <87vckui4ql.fsf@rho.meyering.net>
References: <1334943408-6720-1-git-send-email-jim@meyering.net>
	<1334943408-6720-4-git-send-email-jim@meyering.net>
	<20120420184235.GE1957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120420184235.GE1957@localhost.localdomain> (Josef Bacik's
	message of "Fri, 20 Apr 2012 14:42:35 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Fri, Apr 20, 2012 at 07:36:47PM +0200, Jim Meyering wrote:
>> From: Jim Meyering <meyering@redhat.com>
>>
>> * restore.c (main): Ensure strncpy-copied dir_name is NUL-terminated.
>> * btrfsctl.c (main): Likewise, for a command-line argument.
>> * utils.c (multiple functions): Likewise.
>> * btrfs-list.c (add_root): Likewise.
>> * btrfslabel.c (change_label_unmounted): Likewise.
>> * cmds-device.c (cmd_add_dev, cmd_rm_dev, cmd_scan_dev): Likewise.
>> * cmds-filesystem.c (cmd_resize): Likewise.
>> * cmds-subvolume.c (cmd_subvol_create, cmd_subvol_delete, cmd_snapshot):
>> Likewise.
...
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index 950fa8f..fc749f1 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -111,6 +111,7 @@ static int cmd_subvol_create(int argc, char **argv)
>>
>>  	printf("Create subvolume '%s/%s'\n", dstdir, newname);
>>  	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
>> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>>  	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
>>  	e = errno;
>>
>> @@ -202,6 +203,7 @@ static int cmd_subvol_delete(int argc, char **argv)
>>
>>  	printf("Delete subvolume '%s/%s'\n", dname, vname);
>>  	strncpy(args.name, vname, BTRFS_PATH_NAME_MAX);
>> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>>  	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
>>  	e = errno;
>>
>> @@ -378,6 +380,7 @@ static int cmd_snapshot(int argc, char **argv)
>>
>>  	args.fd = fd;
>>  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
>> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;

Hi Josef,
Thanks for the reviews.

I've moved the parenthesis-fix you noticed, and have just noticed
that I used the wrong symbol name above.

The following change is folded into the PATCHv2 I'm about to post:

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index fc749f1..a01c830 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -380,7 +380,7 @@ static int cmd_snapshot(int argc, char **argv)

 	args.fd = fd;
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
-	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
+	args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;
