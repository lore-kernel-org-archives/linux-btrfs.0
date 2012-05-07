From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Add missing printing newlines
Date: Mon, 7 May 2012 09:23:51 +0200
Message-ID: <20120507072351.GD19331@twin.jikos.cz>
References: <1336369131-6330-1-git-send-email-daniel@quora.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336369131-6330-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2012 at 01:38:51PM +0800, Daniel J Blueman wrote:
> Fix BTRFS messages to print a newline where there should be one.

Please prefix the patch subject line with 'btrfs: '

> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1501,7 +1501,7 @@ static int btrfs_interface_init(void)
>  static void btrfs_interface_exit(void)
>  {
>  	if (misc_deregister(&btrfs_misc) < 0)
> -		printk(KERN_INFO "misc_deregister failed for control device");
> +		printk(KERN_INFO "misc_deregister failed for control device\n");

		printk(KERN_INFO "btrfs: misc_deregister failed for control device\n");

and here as well, otherwise ok, thanks.

david
