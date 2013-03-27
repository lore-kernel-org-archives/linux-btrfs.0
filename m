Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43324 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3C0Oo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 10:44:27 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa10so2178998pad.27
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 07:44:26 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] btrfs-progs: add quota-related info to usage messages
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5152FA04.8080400@oracle.com>
Date: Wed, 27 Mar 2013 22:44:20 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-Id: <4BA76667-80C4-49A3-8194-C096C18B0519@gmail.com>
References: <5152FA04.8080400@oracle.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Extending usage messages with some info on the quota functionality:
>    - The -i option of "subvol create" and "subvol snapshot" was not documented
>    - The -c option of "qgroup limit" is the default option
>    - The "qouta rescan" command is not yet implemented, while it should be
>      executed after enabling quota on a non-empty filesystem.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>

These usage mesaages are really helpful now for users to try  btrfs quota.

David, would you please pull this patch.

Thanks,
Wang

> ---
> cmds-qgroup.c    |    3 ++-
> cmds-quota.c     |    4 ++++
> cmds-subvolume.c |   11 ++++++++---
> 3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index 275f00f..95aca9b 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -326,7 +326,8 @@ static const char * const cmd_qgroup_limit_usage[] = {
>     "btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
>     "Limit the size of a subvolume quota group.",
>     "",
> -    "-c   limit amount of data after compression",
> +    "-c   limit amount of data after compression. This is the default,",
> +    "     it is currently not possible to turn off this option.",
>     "-e   limit space exclusively assigned to this qgroup",
>     NULL
> };
> diff --git a/cmds-quota.c b/cmds-quota.c
> index 8481514..71cd9f1 100644
> --- a/cmds-quota.c
> +++ b/cmds-quota.c
> @@ -64,6 +64,9 @@ int quota_ctl(int cmd, int argc, char **argv)
> static const char * const cmd_quota_enable_usage[] = {
>     "btrfs quota enable <path>",
>     "Enable subvolume quota support for a filesystem.",
> +    "Any data already present on the filesystem will not count towards",
> +    "the space usage numbers. It is recommended to enable quota for a",
> +    "filesystem before writing any data to it.",
>     NULL
> };
> 
> @@ -92,6 +95,7 @@ static int cmd_quota_disable(int argc, char **argv)
> static const char * const cmd_quota_rescan_usage[] = {
>     "btrfs quota rescan <path>",
>     "Rescan the subvolume for a changed quota setting.",
> +    "Not yet implemented.",
>     NULL
> };
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 74e2130..b762470 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -61,10 +61,13 @@ static int test_isdir(char *path)
> }
> 
> static const char * const cmd_subvol_create_usage[] = {
> -    "btrfs subvolume create [<dest>/]<name>",
> +    "btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>",
>     "Create a subvolume",
>     "Create a subvolume <name> in <dest>.  If <dest> is not given",
>     "subvolume <name> will be created in the current directory.",
> +    "",
> +    "-i <qgroupid>  add the newly created subvolume to a qgroup. This",
> +    "               option can be given multiple times.",
>     NULL
> };
> 
> @@ -480,12 +483,14 @@ out:
> }
> 
> static const char * const cmd_snapshot_usage[] = {
> -    "btrfs subvolume snapshot [-r] <source> [<dest>/]<name>",
> +    "btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> [<dest>/]<name>",
>     "Create a snapshot of the subvolume",
>     "Create a writable/readonly snapshot of the subvolume <source> with",
>     "the name <name> in the <dest> directory",
>     "",
> -    "-r     create a readonly snapshot",
> +    "-r             create a readonly snapshot",
> +    "-i <qgroupid>  add the newly created snapshot to a qgroup. This",
> +    "               option can be given multiple times.",
>     NULL
> };
> 
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

