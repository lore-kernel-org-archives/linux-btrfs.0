Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaFRQS3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 12:18:29 -0400
Message-ID: <53A1BBD2.4080208@redhat.com>
Date: Wed, 18 Jun 2014 11:18:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
References: <5398D475.4070309@redhat.com> <5398D4DF.9080508@redhat.com> <20140612105151.GN1903@twin.jikos.cz> <5399BB92.2070205@redhat.com> <20140618152906.GW1903@twin.jikos.cz>
In-Reply-To: <20140618152906.GW1903@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/18/14, 10:29 AM, David Sterba wrote:
> On Thu, Jun 12, 2014 at 09:39:14AM -0500, Eric Sandeen wrote:
>>> So what if the mount options are generated from btrfs-mount.txt but
>>> installed under btrfs.5.gz name? If there are more section 5 manpages we
>>> can make it more generic but for now hardcoding btrfs-mount.* ->
>>> btrfs.5. sounds ok to me.
>>
>> Yeah, that seemed like kind of nasty hard-coding, but I suppose it works
>> for now.  I wanted to make it more generic, I didn't have a better idea..
> 
> Added:
> 
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -85,6 +85,9 @@ install-man: man
>         $(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
>         $(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
>         $(INSTALL) -m 644 $(GZ_MAN5) $(DESTDIR)$(man5dir)
> +       # the source file name of btrfs.5 clashes with section 8 page, but we
> +       # want to keep the code generic
> +       mv $(DESTDIR)$(man5dir)/btrfs-mount.5.gz $(DESTDIR)$(man5dir)/btrfs.5.gz
>         $(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
>         $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
> 
> So the MAN5 code is generic, the exception is only at the installation time.
> 

Looks good to me, thanks.

-Eric
