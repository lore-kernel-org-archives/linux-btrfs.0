From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 14:12:33 +0200
Message-ID: <201008201412.33334.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 20 August, 2010, Goffredo Baroncelli wrote:
> On Thursday, 19 August, 2010, James Smith wrote:
> > This patch randomizes the error codes and also fixes up some typos 
> including
> > capitalization in the output.

I think that you should also update the btrfs man page in order to reflect 
your changing:
- the capitalization of the command arguments
- the list of error codes for every commands

Regards
G.Baroncelli


> > It would almost be nice to see a translation effort for the tool as well.
> > 
> 
> Hi James,
> 
> I don't comment the changing the capitalization. Regarding the other 
changes:
> 
> [...]
>  {
>  	struct Command *cp;
>  
> -	printf("Usage:\n");
> +	printf("VFS-2593 %s\n", BTRFS_BUILD_VERSION);
>                 ^^^^^^^^
> 
> What means VFS-2593 ?
> 
> +	printf("\nNo matter where you go, there you are.\n");
> 
> Is it really useful this kind of comment ?
> 
> 
> [...]
> 
> +			fprintf(stderr, "ERR-A.11: in command '");
> 
> I am not against this kind of error codes, but I prefer
> 
> +			fprintf(stderr, "Error 'ERR-A.11' in command '");
> 
> And a file.txt which details the error codes (otherwise these errors are 
not 
> very useful).
> 
> Why some error codes contain a dot (see ERR-C.13) and others not (like ERR-
> A3) ?
> 
> 
> Reagrds
> G.Baroncelli
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) 
> <kreijackATinwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
