Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbaGCQvr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 12:51:47 -0400
Date: Thu, 3 Jul 2014 18:51:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: add ask_user confirmation for btrfstune
 clear seeding flag
Message-ID: <20140703165145.GG1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 10:06:33AM +0800, Gui Hecheng wrote:
> Clear the seeding flag may cause the original filesystem to be writable,
> which is dangerous.

Can you please describe the dangerous scenario a bit more? This would
also go to the documentation so it's not only to satisfy my curiosity.

Dropping the seeding flag could be dangerous if the filesystem starts in
seeding mode, a new device is added, some writes are done, then
filesystem is unmounted.

Now it's a 2 device filesystem, where the orignal holds some data and
without the seeding flag it would accept new writes. Still ok for me,
though this is probably the time where some user assumptions may break.

> In this case, add user confirmation check when clearing seeding flag.
> Also warn the user that the fs is in a dangerous condition when
> the seeding flag is cleared if it it forced to.

The -y option is tied only to the seeding option, but it should IMO be
more general and called --force.

> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  btrfstune.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/btrfstune.c b/btrfstune.c
> index 3f2f0cd..0e18088 100644
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -103,6 +104,7 @@ static void print_usage(void)
>  	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
>  	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
>  	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
> +	fprintf(stderr, "\t-y \t\tsay yes to clear the seeding flag, make sure that you are aware of the danger\n");

The help text could say someting like

		"--force\tallow dangerous changes\n"

btrfstune only allows setting the bit for extref and skinny-metadata,
unsetting would be dangerous as well.
