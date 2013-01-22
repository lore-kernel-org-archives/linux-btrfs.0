Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:55744 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3AVVpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:45:16 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122214515.XELZ17456.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 16:45:15 -0500
Message-ID: <50FF086A.2030200@czarc.net>
Date: Tue, 22 Jan 2013 16:45:14 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com, jbacik@fusionio.com
Subject: Re: [PATCH 3/6] Fedora 18 - fix-labels.patch
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-4-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-4-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the source of this patch:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg01850.html

and  the update that is the current patch:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg01851.html

Gene

On 01/19/2013 01:06 PM, Gene Czarcinski wrote:
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>   mkfs.c | 7 -------
>   1 file changed, 7 deletions(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index d123d5f..8c291c9 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -352,7 +352,6 @@ static u64 parse_profile(char *s)
>   
>   static char *parse_label(char *input)
>   {
> -	int i;
>   	int len = strlen(input);
>   
>   	if (len >= BTRFS_LABEL_SIZE) {
> @@ -360,12 +359,6 @@ static char *parse_label(char *input)
>   			BTRFS_LABEL_SIZE - 1);
>   		exit(1);
>   	}
> -	for (i = 0; i < len; i++) {
> -		if (input[i] == '/' || input[i] == '\\') {
> -			fprintf(stderr, "invalid label %s\n", input);
> -			exit(1);
> -		}
> -	}
>   	return strdup(input);
>   }
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
