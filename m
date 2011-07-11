From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 2/2] add detailed help messages to btrfs command
Date: Mon, 11 Jul 2011 22:35:49 +0200
Message-ID: <4E1B5EA5.2070704@libero.it>
References: <201101231339.36599.kario@wit.edu.pl> <201101231342.43637.kario@wit.edu.pl> <4E1B1309.2080408@jan-o-sch.net> <4E1B430C.3020008@libero.it> <4E1B4ADC.1000202@jan-o-sch.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Hubert Kario <kario@wit.edu.pl>,
	Hugo Mills <hugo@carfax.org.uk>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1B4ADC.1000202@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/2011 09:11 PM, Jan Schmidt wrote:
> On 07/11/2011 08:38 PM, Goffredo Baroncelli wrote:
>> what about generating the man page on the basis of the btrfs help
>> detailed messages ?
>>
>> My idea is the following:
>> before the function source associated to the command we can put a
>> comment with a detailed help. The comment may be:
>>
>> [...]
>> /*** man:btrfs subvolume create
>>  *
>>  *  btrfs subvolume create <path>
>>  *     create a new subvolume
>>  *
>>  *  The command [b]btrfs subvolume create[b] is used.....
>>  *
>>  ***/
>>
>> void do_create_subvolume(int argc, char **argv)
>> {
>> [...]
> 
> Reminds me of java, but nevertheless, I like the general idea.
> 
>> A script extracts from the comment in the source both:
>> - the text for the man page
>> - the text for the detailed help.
> 
> Does anybody have such a script around? I suppose we're not the first
> ones writing help texts and man pages.
> 

I am trying to write a my own (yes I know, I suffer of the NIH syndrome
:-) ).

>> So we can reach the following goals:
>> - the help is linked to the code
>> - is less likely to forget to update the message
>> - the man page, the helps are always aligned
> 
> Only, we still will need like short and long help. E.g. the full text in
> the man page may be inappropriate as a --help message. Also, we do need
> a clever idea to get indentation right in the man pages. I fiddled a lot
> on the man pages for scrub parameter indentation (to get the second line
> describing a command line option indented correctly to start below the
> text of the first line, that was).

I agree for the short and long help. I think that we need to use some
tags for the bold, italic, Empty line...

> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

