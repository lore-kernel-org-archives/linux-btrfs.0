Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab3AaIyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 03:54:41 -0500
Date: Thu, 31 Jan 2013 09:54:32 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
cc: Gene Czarcinski <gene@czarc.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs-progs: move path modification to filters
In-Reply-To: <alpine.LFD.2.00.1301310740110.5862@dhcp-1-104.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1301310950500.14328@dhcp-1-104.brq.redhat.com>
References: <1355235900-10252-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1301101302140.22820@dhcp-1-104.brq.redhat.com> <alpine.LFD.2.00.1301301432030.28271@dhcp-1-104.brq.redhat.com> <51096072.8010205@czarc.net>
 <alpine.LFD.2.00.1301310740110.5862@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-498601810-1359622474=:14328"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-498601810-1359622474=:14328
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 31 Jan 2013, Luká¨ Czerner wrote:

> Date: Thu, 31 Jan 2013 07:40:37 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Gene Czarcinski <gene@czarc.net>
> Cc: Luká¨ Czerner <lczerner@redhat.com>,
>     linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: Re: [PATCH 1/3] Btrfs-progs: move path modification to filters
> 
> On Wed, 30 Jan 2013, Gene Czarcinski wrote:
> 
> > Date: Wed, 30 Jan 2013 13:03:30 -0500
> > From: Gene Czarcinski <gene@czarc.net>
> > To: Luká¨ Czerner <lczerner@redhat.com>
> > Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
> > Subject: Re: [PATCH 1/3] Btrfs-progs: move path modification to filters
> > 
> > Ignoring for the moment whether these patches are a good idea or not, what is
> > the base upon which these patches were built.  You might want to consider
> > rebasing them to David Sterba's integration-20130130
> > 
> > Gene
> 
> Hi,
> 
> yet it has been a while since I've posted it so I guess I have to
> rebase.

Just to be sure sure I have to ask. Which is the btrfs-progs repository/branch
I should base my work on ? Currently I am using repostitory

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

and master branch. Is that ok ?

Thanks!
-Lukas

> 
> Thanks!
> -Lukas
> 
> > 
> > On 01/30/2013 08:32 AM, Luká¨ Czerner wrote:
> > > On Thu, 10 Jan 2013, Luká¨ Czerner wrote:
> > > 
> > > > Date: Thu, 10 Jan 2013 13:02:42 +0100 (CET)
> > > > From: Luká¨ Czerner <lczerner@redhat.com>
> > > > To: Lukas Czerner <lczerner@redhat.com>
> > > > Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
> > > > cwillu@cwillu.com
> > > > Subject: Re: [PATCH 1/3] Btrfs-progs: move path modification to filters
> > > > 
> > > > On Tue, 11 Dec 2012, Lukas Czerner wrote:
> > > > 
> > > > > Date: Tue, 11 Dec 2012 15:24:58 +0100
> > > > > From: Lukas Czerner <lczerner@redhat.com>
> > > > > To: linux-btrfs@vger.kernel.org
> > > > > Cc: chris.mason@fusionio.com, cwillu@cwillu.com,
> > > > >      Lukas Czerner <lczerner@redhat.com>
> > > > > Subject: [PATCH 1/3] Btrfs-progs: move path modification to filters
> > > > > 
> > > > > Commit 8e8e019e910f20947fea7eff5da40753639d8870 introduces -a option
> > > > > which will list all subvolumes with distinguishing between relative and
> > > > > absolute by prepending absolute patch with "<FS_TREE>".
> > > > > 
> > > > > This commit moves the path modification to a filter code rather than
> > > > > doing so in path construction in resolve_root(). This gives us more
> > > > > flexibility in formatting path output.
> > > > ping
> > > > 
> > > > any comments on this ?
> > > > 
> > > > -Lukas
> > > ping
> > > 
> > > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > > ---
> > > > >   btrfs-list.c     |   32 +++++++++++++++++++++++---------
> > > > >   btrfs-list.h     |    1 +
> > > > >   cmds-subvolume.c |   11 +++++++++--
> > > > >   man/btrfs.8.in   |    3 ++-
> > > > >   4 files changed, 35 insertions(+), 12 deletions(-)
> > > > > 
> > > > > diff --git a/btrfs-list.c b/btrfs-list.c
> > > > > index e5f0f96..77d99f8 100644
> > > > > --- a/btrfs-list.c
> > > > > +++ b/btrfs-list.c
> > > > > @@ -628,15 +628,6 @@ static int resolve_root(struct root_lookup *rl,
> > > > > struct root_info *ri,
> > > > >   		}
> > > > >     		if (next == BTRFS_FS_TREE_OBJECTID) {
> > > > > -			char p[] = "<FS_TREE>";
> > > > > -			add_len = strlen(p);
> > > > > -			len = strlen(full_path);
> > > > > -			tmp = malloc(len + add_len + 2);
> > > > > -			memcpy(tmp + add_len + 1, full_path, len);
> > > > > -			tmp[add_len] = '/';
> > > > > -			memcpy(tmp, p, add_len);
> > > > > -			free(full_path);
> > > > > -			full_path = tmp;
> > > > >   			ri->top_id = next;
> > > > >   			break;
> > > > >   		}
> > > > > @@ -1176,6 +1167,28 @@ static int filter_topid_equal(struct root_info
> > > > > *ri, u64 data)
> > > > >   	return ri->top_id == data;
> > > > >   }
> > > > >   +static int filter_full_path(struct root_info *ri, u64 data)
> > > > > +{
> > > > > +	if (ri->full_path && ri->top_id != data) {
> > > > > +		char *tmp;
> > > > > +		char p[] = "<FS_TREE>";
> > > > > +		int add_len = strlen(p);
> > > > > +		int len = strlen(ri->full_path);
> > > > > +
> > > > > +		tmp = malloc(len + add_len + 2);
> > > > > +		if (!tmp) {
> > > > > +			fprintf(stderr, "memory allocation failed\n");
> > > > > +			exit(1);
> > > > > +		}
> > > > > +		memcpy(tmp + add_len + 1, ri->full_path, len);
> > > > > +		tmp[add_len] = '/';
> > > > > +		memcpy(tmp, p, add_len);
> > > > > +		free(ri->full_path);
> > > > > +		ri->full_path = tmp;
> > > > > +	}
> > > > > +	return 1;
> > > > > +}
> > > > > +
> > > > >   static btrfs_list_filter_func all_filter_funcs[] = {
> > > > >   	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
> > > > >   	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
> > > > > @@ -1187,6 +1200,7 @@ static btrfs_list_filter_func all_filter_funcs[] =
> > > > > {
> > > > >   	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
> > > > >   	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
> > > > >   	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
> > > > > +	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
> > > > >   };
> > > > >     struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
> > > > > diff --git a/btrfs-list.h b/btrfs-list.h
> > > > > index cde4b3c..f7fbea6 100644
> > > > > --- a/btrfs-list.h
> > > > > +++ b/btrfs-list.h
> > > > > @@ -71,6 +71,7 @@ enum btrfs_list_filter_enum {
> > > > >   	BTRFS_LIST_FILTER_CGEN_LESS,
> > > > >   	BTRFS_LIST_FILTER_CGEN_MORE,
> > > > >   	BTRFS_LIST_FILTER_TOPID_EQUAL,
> > > > > +	BTRFS_LIST_FILTER_FULL_PATH,
> > > > >   	BTRFS_LIST_FILTER_MAX,
> > > > >   };
> > > > >   diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> > > > > index ac39f7b..37cb8cc 100644
> > > > > --- a/cmds-subvolume.c
> > > > > +++ b/cmds-subvolume.c
> > > > > @@ -277,7 +277,9 @@ static const char * const cmd_subvol_list_usage[] =
> > > > > {
> > > > >   	"List subvolumes (and snapshots)",
> > > > >   	"",
> > > > >   	"-p           print parent ID",
> > > > > -	"-a           print all the subvolumes in the filesystem.",
> > > > > +	"-a           print all the subvolumes in the filesystem and",
> > > > > +	"             distinguish absolute and relative path with respect",
> > > > > +	"             to the given <path>",
> > > > >   	"-u           print the uuid of subvolumes (and snapshots)",
> > > > >   	"-t           print the result as a table",
> > > > >   	"-s           list snapshots only in the filesystem",
> > > > > @@ -400,7 +402,12 @@ static int cmd_subvol_list(int argc, char **argv)
> > > > >   	}
> > > > >     	top_id = btrfs_list_get_path_rootid(fd);
> > > > > -	if (!is_list_all)
> > > > > +
> > > > > +	if (is_list_all)
> > > > > +		btrfs_list_setup_filter(&filter_set,
> > > > > +					BTRFS_LIST_FILTER_FULL_PATH,
> > > > > +					top_id);
> > > > > +	else
> > > > >   		btrfs_list_setup_filter(&filter_set,
> > > > >   					BTRFS_LIST_FILTER_TOPID_EQUAL,
> > > > >   					top_id);
> > > > > diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> > > > > index 9222580..d6d8e94 100644
> > > > > --- a/man/btrfs.8.in
> > > > > +++ b/man/btrfs.8.in
> > > > > @@ -124,7 +124,8 @@ and top level. The parent's ID may be used at mount
> > > > > time via the
> > > > >     \fB-t\fP print the result as a table.
> > > > >   -\fB-a\fP print all the subvolumes in the filesystem.
> > > > > +\fB-a\fP print all the subvolumes in the filesystem and distinguish
> > > > > between
> > > > > +absolute and relative path with respect to the given <path>.
> > > > >     \fB-r\fP only readonly subvolumes in the filesystem wille be listed.
> > > > >   
> > 
> > 
--571107329-498601810-1359622474=:14328--
