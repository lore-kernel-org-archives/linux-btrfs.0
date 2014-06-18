Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61521 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbaFRU7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 16:59:51 -0400
Received: by mail-oa0-f46.google.com with SMTP id m1so3152023oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 13:59:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140618152906.GW1903@twin.jikos.cz>
References: <5398D475.4070309@redhat.com>
	<5398D4DF.9080508@redhat.com>
	<20140612105151.GN1903@twin.jikos.cz>
	<5399BB92.2070205@redhat.com>
	<20140618152906.GW1903@twin.jikos.cz>
Date: Wed, 18 Jun 2014 21:59:50 +0100
Message-ID: <CALOYprVo60UrZWWVk34MDur6CpDAG2a1Cg3cWd0M__gWKnQywA@mail.gmail.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 June 2014 16:29, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jun 12, 2014 at 09:39:14AM -0500, Eric Sandeen wrote:
>> > So what if the mount options are generated from btrfs-mount.txt but
>> > installed under btrfs.5.gz name? If there are more section 5 manpages we
>> > can make it more generic but for now hardcoding btrfs-mount.* ->
>> > btrfs.5. sounds ok to me.
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi David,

I think you forgot to apply the patch that adds
Documentation/btrfs-mount.5.txt before you tagged
integration-20140618, man5 (and consequently Documentation) can't be
made without it, causing a failed build.

make: *** No rule to make target 'btrfs-mount.5.gz', needed by 'man5'.  Stop.

Any chance of a quick fix and a -2 tag?

Cheers,


WorMzy
