Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55317 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BZUkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:40:52 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so2808596eek.9
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 12:40:51 -0800 (PST)
Date: Tue, 26 Feb 2013 22:40:40 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/17 V2] btrfs-progs: replace strtok_r with strsep
Message-ID: <20130226204040.GA1993@zambezi.lan>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
 <1361832890-40921-18-git-send-email-sandeen@redhat.com>
 <512D0325.5050308@gmail.com>
 <512D190E.2050002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512D190E.2050002@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 02:20:30PM -0600, Eric Sandeen wrote:
> The coverity runs had a false positive complaining that save_ptr
> is uninitialized in the call to strtok_r.
> 
> We could initialize it, but Zach points out that just using
> strsep is a lot simpler if there's only one delimiter,
> so just switch to that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Remove accidentally-added debug printfs, thanks Geoffredo!
> 
> diff --git a/cmds-balance.c b/cmds-balance.c
> index b671e1d..cfbb8eb 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -67,11 +67,8 @@ static int parse_one_profile(const char *profile, u64 *flags)
>  static int parse_profiles(char *profiles, u64 *flags)
>  {
>  	char *this_char;
> -	char *save_ptr;
>  
> -	for (this_char = strtok_r(profiles, "|", &save_ptr);
> -	     this_char != NULL;
> -	     this_char = strtok_r(NULL, "|", &save_ptr)) {
> +	while ((this_char = strsep(&profiles, "|"))) {
>  		if (parse_one_profile(this_char, flags))
>  			return 1;
>  	}
> @@ -136,14 +133,11 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
>  {
>  	char *this_char;
>  	char *value;
> -	char *save_ptr;
>  
>  	if (!filters)
>  		return 0;
>  
> -	for (this_char = strtok_r(filters, ",", &save_ptr);
> -	     this_char != NULL;
> -	     this_char = strtok_r(NULL, ",", &save_ptr)) {
> +	while ((this_char = strsep(&filters , ","))) {

					  ^^^ whitespace


One of the differences between strtok() and strsep() is that the former
allows multiple delimiters between two tokens.  With strsep(), this

btrfs balance -dfoo1=bar1,,,foo2=bar2 <mnt>

fails with error, whereas with strtok() it passes.  I don't have a
strong opinion here (this has been loosely modeled on the way mount(8)
handles -o options), but might it be better to just initialize save_ptr?
(And yes, I know that strsep() is better ;))

Thanks,

		Ilya
