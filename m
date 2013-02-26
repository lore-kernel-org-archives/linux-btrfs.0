Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:60613 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3BZSpp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 13:45:45 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so2611182eei.17
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 10:45:44 -0800 (PST)
Message-ID: <512D0325.5050308@gmail.com>
Date: Tue, 26 Feb 2013 19:47:01 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/17] btrfs-progs: replace strtok_r with strsep
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-18-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-18-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2013 11:54 PM, Eric Sandeen wrote:
> The coverity had a false positive complaining that save_ptr
> is uninitialized in the call to strtok_r.
> 
> We could initialize it, but Zach points out that just using
> strsep is a lot simpler if there's only one delimiter,
> so just switch to that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  cmds-balance.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/cmds-balance.c b/cmds-balance.c
> index b671e1d..e8b9d90 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -67,11 +67,9 @@ static int parse_one_profile(const char *profile, u64 *flags)
>  static int parse_profiles(char *profiles, u64 *flags)
>  {
>  	char *this_char;
> -	char *save_ptr;
>  
> -	for (this_char = strtok_r(profiles, "|", &save_ptr);
> -	     this_char != NULL;
> -	     this_char = strtok_r(NULL, "|", &save_ptr)) {
> +	while ((this_char = strsep(&profiles, "|"))) {
> +		printf("got profile %s\n", this_char);

In the  original code the printf() doesn't exist. May be this is a
residual of a debugging code ?

>  		if (parse_one_profile(this_char, flags))
>  			return 1;
>  	}
> @@ -136,14 +134,12 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
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
> +		printf("got %s\n", this_char);

Same here

>  		if ((value = strchr(this_char, '=')) != NULL)
>  			*value++ = 0;
>  		if (!strcmp(this_char, "profiles")) {


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
