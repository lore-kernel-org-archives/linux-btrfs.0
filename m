Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58555 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2JOLrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 07:47:23 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for different unit.
Date: Mon, 15 Oct 2012 13:47:17 +0200
Cc: Goffredo Baroncelli <kreijack@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dave@jikos.cz>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <1350156436-14439-1-git-send-email-kreijack@gmail.com> <1350156436-14439-2-git-send-email-kreijack@gmail.com> (sfid-20121014_015034_208055_B4C44C97)
In-Reply-To: <1350156436-14439-2-git-send-email-kreijack@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210151347.17730.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 13. Oktober 2012 schrieb Goffredo Baroncelli:
> From: Goffredo Baroncelli <kreijack@inwind.it>
> 
> The function pretty_sizes() returns a string containing the passed
> number. It add a suffix depending by the number: eg KiB, MiB.
> This change replace the old SI suffix (KB, MB..) by the IEC
> ones (KiB, MiB..). Moreover a space is added between the suffix
> and the number.
> 
> Setting opprtunately the enviroment variable BTRFS_UNIT, it is

opprtunately => how its written without typo :)

(I didn´t find it in dict.leo.org, maybe due to my writing of it is wrong
as well)

Anyway pretty minor.

And thanks for the patches to improve size reporting. I try to give them a
test this week and unit setting.

> possible to:
> BTRFS_UNIT=SI the suffix is KB for 1000bytes, MB for 10^6 bytes...
> BTRFS_UNIT=IEC the suffix is KiB for 1024bytes, MiB for 1024 KiB ...
> BTRFS_UNIT=COMPACT the suffix is KB for 1024 bytes, MB for 1024 KiB;
>                    no space between the number and the suffix.
> 
> See http://en.wikipedia.org/wiki/Byte for further information about
> the different suffix.
> ---
>  utils.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 61 insertions(+), 9 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index 205e667..8528cc1 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1085,33 +1085,85 @@ out:
>  	return ret;
>  }
>  
> -static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
> +static char *size_strs_inf[] = { "", "KiB", "MiB", "GiB", "TiB",
> +			    "PiB", "EiB", "ZiB", "YiB"};
> +static char *size_strs_dec[] = { "", "KB", "MB", "GB", "TB",
>  			    "PB", "EB", "ZB", "YB"};
> +
> +static int which_unit( ){
> +	static int unit=-1;
> +	char	*u;
> +
> +	if( unit != -1 )
> +		return unit;
> +
> +	unit = 0;
> +
> +	u =getenv("BTRFS_UNIT");
> +	if(!u) return 0;
> +
> +	if( !strcmp(u,"SI") )
> +		unit = 1;
> +	else if( !strcmp(u, "COMPACT") )
> +		unit = 2;
> +	else if( !strcmp(u, "IEC") )
> +		unit = 0;
> +	/* else
> +		Shall we raise an error ? 
> +	*/
> +		
> +	return unit;
> +
> +}
> +
> +
>  char *pretty_sizes(u64 size)
>  {
>  	int num_divs = 0;
> -        int pretty_len = 16;
> +        int pretty_len = 20;
>  	float fraction;
> -	char *pretty;
> +	char *pretty, *space;
> +	int  shift = 1024;
> +	char **size_strs;
> +
> +	if( which_unit() == 1 ){		/* SI */
> +		shift = 1000;
> +		size_strs = size_strs_dec;
> +		space = " ";
> +	} else if( which_unit() == 2 ){		/* Old method:
> +						   SI suffix, but 
> +						   multiply of 1024 */
> +		shift = 1024;
> +		size_strs = size_strs_dec;
> +		space = "";
> +	}else{
> +		shift = 1024;			/* IEC */
> +		size_strs = size_strs_inf;
> +		space = " ";
> +	}
>  
> -	if( size < 1024 ){
> +	if( size < shift ){
>  		fraction = size;
>  		num_divs = 0;
>  	} else {
>  		u64 last_size = size;
>  		num_divs = 0;
> -		while(size >= 1024){
> +		while(size >= shift){
>  			last_size = size;
> -			size /= 1024;
> +			size /= shift;
>  			num_divs ++;
>  		}
>  
> -		if (num_divs > ARRAY_SIZE(size_strs))
> +		if (num_divs > ARRAY_SIZE(size_strs_inf))
>  			return NULL;
> -		fraction = (float)last_size / 1024;
> +		fraction = (float)last_size / shift;
>  	}
>  	pretty = malloc(pretty_len);
> -	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
> +
> +	snprintf(pretty, pretty_len, "%.2f%s%s", 
> +		fraction, 
> +		space,
> +		size_strs[num_divs]);
>  	return pretty;
>  }
>  
> 


-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
