Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaANQGb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 11:06:31 -0500
Date: Tue, 14 Jan 2014 17:06:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Timothy Pepper <timothy.c.pepper@linux.intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs-progs: Add optional 'uuid' parameter to
 mkfs.btrfs
Message-ID: <20140114160629.GY6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140108215058.GA31124@tcpepper-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140108215058.GA31124@tcpepper-desk.jf.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 01:50:58PM -0800, Timothy Pepper wrote:
> The patch below is a simple quick attempt at allowing the filesystem
> UUID to be specified by the user at mkfs time.

There was a similar patch some time ago, that also added it to convert:
http://www.spinics.net/lists/linux-btrfs/msg21193.html

and my comments apply to your patch as well:
http://www.spinics.net/lists/linux-btrfs/msg22889.html

"Can you please enhance it with a check that the UUID is not duplicate
among other filesystems? It should be available through libblkid:

	blkid_probe_lookup_value(probe, "UUID", &uuid, NULL);

This is a sort of paranoia check with the generated UUID, but I think
that an accidentally repeated command or copy&paste with an existing
uuid can happen."

> Googling around I've
> seen a lot of people wishing they could "change their btrfs uuid".
> I understand why that's not going to happen.

Well, the user demand can make it happen. The offline rewrite is easy
but has it's own drawbacks.

It seems doable to do a mount-time change of uuid. Mount a fs under a
different uuid that would become the new one, while still accepting the
previuos uuid when found in metadata. A full scrub pass would convert
the old uuids when reqested.
(This will become a wiki://Project_idea eventually)

> @@ -335,12 +336,25 @@ static char *parse_label(char *input)
>  	return strdup(input);
>  }
>  
> +static char *parse_uuid(char *input)

please use libuuid API instead

> +{
> +	int len = strlen(input);
> +#define	BTRFS_UUID_STRING_SIZE	(2*BTRFS_UUID_SIZE + 5)
> +	if (len >= BTRFS_UUID_STRING_SIZE) {
> +		fprintf(stderr, "UUID %s is too long (max %d)\n", input,
> +			BTRFS_UUID_STRING_SIZE - 1);
> +		exit(1);
> +	}
> +	return strdup(input);
> +}
> +
> @@ -1288,6 +1303,9 @@ int main(int ac, char **av)
>  			case 'L':
>  				label = parse_label(optarg);
>  				break;
> +			case 'U':
> +				uuid = parse_uuid(optarg);

Error handling needed.

> +				break;
>  			case 'm':
>  				metadata_profile = parse_profile(optarg);
>  				metadata_profile_opt = 1;
