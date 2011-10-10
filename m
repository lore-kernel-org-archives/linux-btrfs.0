From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: can't snapshot
Date: Mon, 10 Oct 2011 10:41:04 -0500
Message-ID: <CAKcLGm8H5ZEQfUCsnwk3045OZ9huxqVj1gZc=WqmXpRuVg4iKQ@mail.gmail.com>
References: <4E930BC2.4080405@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E930BC2.4080405@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2011 at 10:14 AM, Jim <jim@webstarts.com> wrote:
> Good morning Btrfs list,
> I am trying to create a subvolume of a directory tree (approximately =
1.1
> million subvolumes under nfs1). =A0The following error is thrown and =
without
> the wiki I don't know what argument is needed. =A0I am running kernel
> 3.1.0-rc4.
>
> [root@btrfs ~]# btrfs sub snapshot /btrfs/nfs1/ /btrfs/snaps/
> Invalid arguments for subvolume snapshot
> [root@btrfs ~]# btrfs sub list /btrfs | head
> ID 256 top level 5 path nfs1
> ID 257 top level 5 path nfs2
> ID 258 top level 5 path nfs2/data
> ID 259 top level 5 path nfs1/data
> ID 260 top level 5 path nfs1/data/sites
> ID 261 top level 5 path nfs2/data/sites
> ID 262 top level 5 path nfs2/data/sites/0420
> ID 263 top level 5 path nfs2/data/sites/0421
> ID 264 top level 5 path nfs2/data/sites/0422
> ID 265 top level 5 path nfs2/data/sites/0423
>
> Any help is appreciated
> Thanks
> Jim

Aha!  You're using Hugo Mills btrfs-progs repository I assume.

I've found it necessary to apply the following patch to Hugo Mills
btrfs-progs repo to get snapshots working:

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 699dfc2..26a4e6f 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -372,7 +372,7 @@ int do_clone(int argc, char **argv)
 			return 1;
 		}
 	}
-	if (argc - optind !=3D 2) {
+	if (argc - optind !=3D 3) {
 		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
 		free(argv);
 		return 1;
--=20

Hugo has indicated to me that he anticipates further modification to
parameter checking that would address this issue, but I'm not sure
where that stands.

Hugo:  Let me know if you want me to send this patch to the list.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
