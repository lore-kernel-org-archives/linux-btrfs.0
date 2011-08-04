From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3] Btrfs-progs: add "btrfs subvolume get-default"
 subcommand
Date: Thu, 4 Aug 2011 21:27:06 +0200
Message-ID: <20110804192706.GF28122@twin.jikos.cz>
References: <1310438917-23048-1-git-send-email-xin.zhong@intel.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310438917-23048-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please move the help text for 'get-default' right after 'set-default',
it's logical and currently it's very easy to miss it (it took me a few
seconds to locate it event if I knew it's there :)

thanks,
david

On Tue, Jul 12, 2011 at 10:48:37AM +0800, Zhong, Xin wrote:
> diff --git a/btrfs.c b/btrfs.c
> index 67d6f6f..1af8360 100644
> --- a/btrfs.c
> +++ b/btrfs.c
@@ -78,6 +78,9 @@ static struct Command commands[] = {
                "as default.",
          NULL
        },
> +	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
> +		"Get the default subvolume of a filesystem."
> +	},
        { do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
                "List the recently modified files in a filesystem.",
          NULL
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> ...
