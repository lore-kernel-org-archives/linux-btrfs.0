Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3IRC07 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 22:26:59 -0400
Message-ID: <52390F72.7030908@redhat.com>
Date: Tue, 17 Sep 2013 21:26:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: rongqing.li@windriver.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add version.h dependency to fix parallel
 builds
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com> <5239084D.4020802@redhat.com>
In-Reply-To: <5239084D.4020802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/17/13 8:56 PM, Eric Sandeen wrote:
> Change the suffix rule to ensure that version.h is 
> built before we try to create any .o file.
> 
> Reported-by: Roy Li <rongqing.li@windriver.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I dunno, does this work?  My gnu make is rusty.

I'm actually confused by what the makefile is doing with the
dependency generation, maybe my patch isn't right.

this:

%.o.d: %.c
        $(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<

completely confuses me :)

-Eric

> diff --git a/Makefile b/Makefile
> index 3d715d8..d25054f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -107,13 +107,13 @@ endif
>  %.o.d: %.c
>  	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
>  
> -.c.o:
> +%.o: %.c version.h
>  	@$(check_echo) "    [SP]     $<"
>  	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
>  
> -%.static.o: %.c
> +%.static.o: %.c version.h
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

