From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Re: [btrfs-progs integration] incorrect argument	checking
 for "btrfs sub snap -r"
Date: Thu, 11 Aug 2011 13:30:48 +0900
Message-ID: <4E435AF8.2010408@jp.fujitsu.com>
References: <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk> <chaz20110630123438.GE28702@seebyte.com> <4E0CE2B3.1080600@gmail.com> <chaz20110701082652.GF28702@seebyte.com> <4E0D9DCA.1090204@gmail.com> <20110701104223.GA7606@carfax.org.uk> <chaz20110701125536.GG28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephane Chazelas <stephane.chazelas@gmail.com>,
	Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110701125536.GG28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Hugo,

I built your for-chris branch, and ran 'btrfs sub snap' command.
Then, I encountered following error message.

  # btrfs sub snap Dir-1 Dir-2
  Invalid arguments for subvolume snapshot

commit:8b4c2a22bff85f86af44587973c8da8c29a67ffc is wrong, I think.

(2011/07/01 21:55), Stephane Chazelas wrote:
> 2011-07-01 11:42:23 +0100, Hugo Mills:
> [...]
>>>> diff --git a/btrfs.c b/btrfs.c
>>>> index e117172..b50c58a 100644
>>>> --- a/btrfs.c
>>>> +++ b/btrfs.c
>>>> @@ -49,7 +49,7 @@ static struct Command commands[] = {
>>>>  	/*
>>>>  		avoid short commands different for the case only
>>>>  	*/
>>>> -	{ do_clone, 2,
>>>> +	{ do_clone, -2,
>>>>  	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
>>>>  		"Create a writable/readonly snapshot of the subvolume <source> with\n"
>>>>  		"the name <name> in the <dest> directory.",
>>>> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
>>>> index 1d18c59..3415afc 100644
>>>> --- a/btrfs_cmds.c
>>>> +++ b/btrfs_cmds.c
>>>> @@ -355,7 +355,7 @@ int do_clone(int argc, char **argv)
>>>>  			return 1;
>>>>  		}
>>>>  	}
>>>> -	if (argc - optind < 2) {
>>>> +	if (argc - optind != 2) {
>>>>  		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
>>>>  		free(argv);
>>>>  		return 1;
>>>>
>>> Thanks for having another look at this. You are perfectly right. Should
>>> we patch my patch or should I rework a corrected version? What do you
>>> think Hugo?
>>
>>    Could you send a follow-up patch with just the second hunk, please?
>> I screwed up the process with this (processing patches too quickly to
>> catch the review), and I've already published the patch with the first
>> hunk, above, into the for-chris branch.
> 
> Hugo, not sure what you mean nor whom you're talking to, but I
> can certainly copy-paste the second hunk from above here:
> 
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

I think that '3' is correct.

Thanks,
Tsutomu

>  		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
>  		free(argv);
>  		return 1;
> 
> Cheers,
> Stephane

