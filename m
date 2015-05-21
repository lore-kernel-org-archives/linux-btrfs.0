Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35515 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbbEUP7p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 11:59:45 -0400
Received: by obcus9 with SMTP id us9so63573330obc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 08:59:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432222949-604-1-git-send-email-jekarlson@gmail.com>
References: <1432222949-604-1-git-send-email-jekarlson@gmail.com>
Date: Thu, 21 May 2015 18:59:44 +0300
Message-ID: <CAELSAVZfVsSkSYT6afsLhQehKrKPJhLqbZ5qV=QXnsT0hyz8AQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: use openat for process_clone in receive
From: Emil Karlson <jekarlson@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: Emil Karlson <jekarlson@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetigns

I actually also tested this... btrfs on PATH is from btrfs-progs-4.0
and the other is the upstream master with the patch

schur log # lzop -dc
/home/sftponly/eira-receive/log/snapshot-2015-05-21T09.52.59N00003f.far.lzo
| /home/jkarlson/.local/repo/btrfs-progs/btrfs receive  $PWD
At snapshot snapshot-2015-05-21T09.52.59N00003f
schur log # find snapshot-2015-05-21T09.52.59N00003f -type f -exec
sha1sum '{}' + | sort > filelist-received && sha1sum filelist-received
&& rm filelist-received
8ecfd188a5c80924784b80267837c24b43be619b  filelist-received
schur log # btrfs sub del
/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f/
Delete subvolume (no-commit):
'/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f'
schur log # lzop -dc
/home/sftponly/eira-receive/log/snapshot-2015-05-21T09.52.59N00003f.far.lzo
| /home/jkarlson/.local/repo/btrfs-progs/btrfs receive -C $PWD
Chroot to /mnt/snapshots/eira/log
At snapshot snapshot-2015-05-21T09.52.59N00003f
schur log # find snapshot-2015-05-21T09.52.59N00003f -type f -exec
sha1sum '{}' + | sort > filelist-received && sha1sum filelist-received
&& rm filelist-received
8ecfd188a5c80924784b80267837c24b43be619b  filelist-received
schur log # btrfs sub del
/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f/
Delete subvolume (no-commit):
'/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f'
schur log # lzop -dc
/home/sftponly/eira-receive/log/snapshot-2015-05-21T09.52.59N00003f.far.lzo
| btrfs receive  $PWD
At snapshot snapshot-2015-05-21T09.52.59N00003f
schur log # find snapshot-2015-05-21T09.52.59N00003f -type f -exec
sha1sum '{}' + | sort > filelist-received && sha1sum filelist-received
&& rm filelist-received
8ecfd188a5c80924784b80267837c24b43be619b  filelist-received
schur log # btrfs sub del
/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f/
Delete subvolume (no-commit):
'/mnt/snapshots/eira/log/snapshot-2015-05-21T09.52.59N00003f'
schur log # lzop -dc
/home/sftponly/eira-receive/log/snapshot-2015-05-21T09.52.59N00003f.far.lzo
| btrfs receive -C  $PWD
Chroot to /mnt/snapshots/eira/log
At snapshot snapshot-2015-05-21T09.52.59N00003f
ERROR: failed to open
/snapshots/eira/log/snapshot-2015-05-15T17.00.28N00001f/journal/1d6156a06c4a45feaef97336a4b154b8/user-1001.journal.
No such file or directory

Best Regards
-Emil

On Thu, May 21, 2015 at 6:42 PM,  <jekarlson@gmail.com> wrote:
> From: Emil Karlson <jekarlson@gmail.com>
>
> This will fix breakage, when doing chrooted receive with cloned paths
> outside main subvolume.
> ---
>  cmds-receive.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/cmds-receive.c b/cmds-receive.c
> index b7cf3f9..b0a312c 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -609,9 +609,9 @@ static int process_clone(const char *path, u64 offset, u64 len,
>                 subvol_path = strdup(si->path);
>         }
>
> -       full_clone_path = path_cat3(r->root_path, subvol_path, clone_path);
> +       full_clone_path = path_cat(subvol_path, clone_path);
>
> -       clone_fd = open(full_clone_path, O_RDONLY | O_NOATIME);
> +       clone_fd = openat(r->mnt_fd, full_clone_path, O_RDONLY | O_NOATIME);
>         if (clone_fd < 0) {
>                 ret = -errno;
>                 fprintf(stderr, "ERROR: failed to open %s. %s\n",
> --
> 2.3.6
>
