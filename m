Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36970 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab2FFVIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jun 2012 17:08:21 -0400
Received: from mx.meyering.net (unknown [88.168.87.75])
	by smtp5-g21.free.fr (Postfix) with ESMTP id A09DDD480DA
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2012 23:08:10 +0200 (CEST)
From: Jim Meyering <jim@meyering.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 3/4] avoid several strncpy-induced buffer overruns
In-Reply-To: <20120606193147.GS15986@carfax.org.uk> (Hugo Mills's message of
	"Wed, 6 Jun 2012 20:31:47 +0100")
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
	<1334950046-24147-4-git-send-email-jim@meyering.net>
	<20120606193147.GS15986@carfax.org.uk>
Date: Wed, 06 Jun 2012 23:08:09 +0200
Message-ID: <87ipf4ywqu.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:
>    Hi, Jim,
>
>    I picked this up to go in integration-*, and Alex Block spotted a
> problem, so I did a bit of a more in-depth review. Comments below.
>
> On Fri, Apr 20, 2012 at 09:27:25PM +0200, Jim Meyering wrote:
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
>>
>> Reviewed-by: Josef Bacik <josef@redhat.com>
>> ---
>>  btrfs-list.c      |    2 ++
>>  btrfsctl.c        |    5 +++--
>>  btrfslabel.c      |    1 +
>>  cmds-device.c     |    3 +++
>>  cmds-filesystem.c |    1 +
>>  cmds-subvolume.c  |    3 +++
>>  restore.c         |    3 ++-
>>  utils.c           |   13 ++++++++++---
>>  8 files changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/btrfs-list.c b/btrfs-list.c
>> index 5f4a9be..35e6139 100644
>> --- a/btrfs-list.c
>> +++ b/btrfs-list.c
>> @@ -183,6 +183,8 @@ static int add_root(struct root_lookup *root_lookup,
>>  	ri->root_id = root_id;
>>  	ri->ref_tree = ref_tree;
>>  	strncpy(ri->name, name, name_len);
>> +	if (name_len > 0)
>> +		ri->name[name_len-1] = 0;
>
>    Alex Block pointed out on IRC that this breaks "btrfs sub list", by
> chopping off the last character of the subvol name. This should
> probably be:
>
> - 	strncpy(ri->name, name, name_len);
> + 	strncpy(ri->name, name, name_len+1);
> +	if (name_len > 0)
> +		ri->name[name_len] = 0;

Hi Hugo,

Thanks for the feedback.
I'll start with this one.  More tomorrow.

Upon re-review, I see that the preceding code does this:

	struct root_info *ri;
	struct rb_node *ret;
	ri = malloc(sizeof(*ri) + name_len + 1);
	if (!ri) {
		printf("memory allocation failed\n");
		exit(1);
	}
	memset(ri, 0, sizeof(*ri) + name_len + 1);

Since that memset has already guaranteed that the final byte
of ri->name is a NUL, the original strncpy is fine, and I should
not have tried to NUL-terminate its buffer:

    strncpy(ri->name, name, name_len);

I.e., it does not need to go to any extra lengths to NUL-terminate.
Hence, we could just drop that hunk.  However, depending on that
memset[*] makes this code unnecessarily fragile, and using strncpy
at all is generally best avoided, and most importantly, since
I doubt that it is ok to use a truncated "name" in ri->name if
strlen(name) ever happens to be longer than name_len, ...

What would you think of a patch to reject a name (currently
merely truncated) that would be too long?  If somehow that
truncation is not possible, then there is no need for strncpy
in the first place.

[*] I would remove the memset-0 altogether, if possible, or at least
fold it into the preceding malloc (i.e., s/malloc/calloc/).
