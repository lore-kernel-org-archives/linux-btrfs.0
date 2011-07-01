From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH] Re: [btrfs-progs integration] incorrect argument checking
 for "btrfs sub snap -r"
Date: Fri, 01 Jul 2011 12:13:30 +0200
Message-ID: <4E0D9DCA.1090204@gmail.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk> <chaz20110630123438.GE28702@seebyte.com> <4E0CE2B3.1080600@gmail.com> <chaz20110701082652.GF28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	Andreas Philipp <philipp.andreas@gmail.com>
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110701082652.GF28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01.07.2011 10:26, Stephane Chazelas wrote:
> 2011-06-30 22:55:15 +0200, Andreas Philipp:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>  
>> On 30.06.2011 14:34, Stephane Chazelas wrote:
>>> Looks like this was missing in integration-20110626 for the
>>> readonly snapshot patch:
>>>
>>> diff --git a/btrfs.c b/btrfs.c
>>> index e117172..be6ece5 100644
>>> --- a/btrfs.c
>>> +++ b/btrfs.c
>>> @@ -49,7 +49,7 @@ static struct Command commands[] = {
>>> /*
>>> avoid short commands different for the case only
>>> */
>>> - { do_clone, 2,
>>> + { do_clone, -1,
>>> "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
>>> "Create a writable/readonly snapshot of the subvolume <source> with\n"
>>> "the name <name> in the <dest> directory.",
>>>
>>> Without that, "btrfs sub snap -r x y" would fail as it's not *2*
>>> arguments.
>> Unfortunately, this is not correct either. "-1" means that the minimum
>> number of arguments is 1 and since we need at least <source> and
>> <name> this is 2. So the correct version should be -2.
> [...]
>
> Sorry, without looking closely at the source, I assumed -1 meant
> defer the checking to the subcommand handler.
>
> do_clone will indeed return an error if the number of arguments
> is less than expected (so with -2, you'll get a different error
> message if you do "btrfs sub snap -r foo" or "btrfs sub snap
> foo") , but will not if it's more than expected by the way.
>
> So the patch should probably be:
>
> diff --git a/btrfs.c b/btrfs.c
> index e117172..b50c58a 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -49,7 +49,7 @@ static struct Command commands[] = {
>  	/*
>  		avoid short commands different for the case only
>  	*/
> -	{ do_clone, 2,
> +	{ do_clone, -2,
>  	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
>  		"Create a writable/readonly snapshot of the subvolume <source> with\n"
>  		"the name <name> in the <dest> directory.",
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 1d18c59..3415afc 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -355,7 +355,7 @@ int do_clone(int argc, char **argv)
>  			return 1;
>  		}
>  	}
> -	if (argc - optind < 2) {
> +	if (argc - optind != 2) {
>  		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
>  		free(argv);
>  		return 1;
>
Thanks for having another look at this. You are perfectly right. Should
we patch my patch or should I rework a corrected version? What do you
think Hugo?

Cheers,
Andreas
