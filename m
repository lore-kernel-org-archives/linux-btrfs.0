Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34565 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbbD0JXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 05:23:48 -0400
Received: by iedfl3 with SMTP id fl3so137967489ied.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 02:23:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553DE512.7080606@giantdisaster.de>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
	<553DE512.7080606@giantdisaster.de>
Date: Mon, 27 Apr 2015 11:23:45 +0200
Message-ID: <CAJ1pDqRsVdTHs0Yki9yrT1ibC7mTn9_Z7JEpZdLb2OJd7z+8Aw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
From: lauri <lauri.vosandi@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> This won't work if you receive more than one snapshot, each one derived
> from the previous one ("btrfs send -e snap1 snap2 snap3 snap4"). You
> would always use the first one as the parent, not the predecessor.
> That's implemented differently for the -p option in
> git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git

I'll take another look on the multi-subvolume stream mode.

> This used to be a search for the received_uuid only. Why is this code
> changed like this in the branch that is executed when -p is not
> specified, in a patch that has the goal to add -p with new functionality
> if -p is specified?

Many things have changed since far-progs, take a look in the original
source I used as basis for my patch:

https://github.com/kdave/btrfs-progs/blob/1b7dd327f43777bcdd217a0500e6bda78128a290/cmds-receive.c#L233

I am pretty sure lookup logic isn't affected if -p is not used.

2015-04-27 9:28 GMT+02:00 Stefan Behrens <sbehrens@giantdisaster.de>:
> On Sun, 26 Apr 2015 12:12:45 +0200, Lauri Võsandi wrote:
>> This patch adds command-line flag -p to btrfs receive
>> which makes it possible to disable automatic parent
>> search for incremental snapshots and use explicitly
>> specified path instead.
>>
>> Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
>> ---
>>  cmds-receive.c | 34 ++++++++++++++++++++++++++--------
>>  1 file changed, 26 insertions(+), 8 deletions(-)
>>
>> diff --git a/cmds-receive.c b/cmds-receive.c
>> index b7cf3f9..391d281 100644
>> --- a/cmds-receive.c
>> +++ b/cmds-receive.c
>> @@ -61,6 +61,7 @@ struct btrfs_receive
>>       char *root_path;
>>       char *dest_dir_path; /* relative to root_path */
>>       char *full_subvol_path;
>> +     char *explicit_parent_path;
>>       int dest_dir_chroot;
>>
>>       struct subvol_info *cur_subvol;
>> @@ -220,20 +221,32 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>>               fprintf(stderr, "receiving snapshot %s uuid=%s, "
>>                               "ctransid=%llu ", path, uuid_str,
>>                               r->cur_subvol->stransid);
>> -             uuid_unparse(parent_uuid, uuid_str);
>> -             fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
>> -                             uuid_str, parent_ctransid);
>>       }
>>
>>       memset(&args_v2, 0, sizeof(args_v2));
>>       strncpy_null(args_v2.name, path);
>>
>> -     parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
>> -                     parent_ctransid, NULL, subvol_search_by_received_uuid);
>> -     if (!parent_subvol) {
>> +     if (r->explicit_parent_path) {
>> +             if (g_verbose) {
>> +                     fprintf(stderr, "using explicit parent %s\n",
>> +                                     r->explicit_parent_path);
>> +             }
>> +             parent_subvol = subvol_uuid_search(&r->sus, 0, NULL,
>> +                     0, r->explicit_parent_path, subvol_search_by_path);
>
> This won't work if you receive more than one snapshot, each one derived
> from the previous one ("btrfs send -e snap1 snap2 snap3 snap4"). You
> would always use the first one as the parent, not the predecessor.
> That's implemented differently for the -p option in
> git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git
>
>
>> +     } else {
>> +             if (g_verbose) {
>> +                     uuid_unparse(parent_uuid, uuid_str);
>> +                     fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
>> +                                     uuid_str, parent_ctransid);
>> +             }
>>               parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
>> -                             parent_ctransid, NULL, subvol_search_by_uuid);
>> +                     parent_ctransid, NULL, subvol_search_by_received_uuid);
>> +             if (!parent_subvol) {
>> +                     parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
>> +                                     parent_ctransid, NULL, subvol_search_by_uuid);
>> +             }
>
> This used to be a search for the received_uuid only. Why is this code
> changed like this in the branch that is executed when -p is not
> specified, in a patch that has the goal to add -p with new functionality
> if -p is specified?
>
>
>>       }
>> +
>>       if (!parent_subvol) {
>>               ret = -ENOENT;
>>               fprintf(stderr, "ERROR: could not find parent subvolume\n");
>> @@ -962,11 +975,14 @@ int cmd_receive(int argc, char **argv)
>>                       { NULL, 0, NULL, 0 }
>>               };
>>
>> -             c = getopt_long(argc, argv, "Cevf:", long_opts, NULL);
>> +             c = getopt_long(argc, argv, "Cevf:p:", long_opts, NULL);
>>               if (c < 0)
>>                       break;
>>
>>               switch (c) {
>> +             case 'p':
>> +                     r.explicit_parent_path = optarg;
>> +                     break;
>>               case 'v':
>>                       g_verbose++;
>>                       break;
>> @@ -1028,6 +1044,8 @@ const char * const cmd_receive_usage[] = {
>>       "                 in the data stream. Without this option,",
>>       "                 the receiver terminates only if an error",
>>       "                 is recognized or on EOF.",
>> +     "-p <subvol>      Disables the automatic searching for parents",
>> +     "                 if incremental streams are received.",
>>       "-C|--chroot      confine the process to <mount> using chroot",
>>       "--max-errors <N> Terminate as soon as N errors happened while",
>>       "                 processing commands from the send stream.",
>>
>



-- 
Lauri Võsandi
tel: +372 53329412
e-mail: lauri.vosandi@gmail.com
blog: http://lauri.vosandi.com/
