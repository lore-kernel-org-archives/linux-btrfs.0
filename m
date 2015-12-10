Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vwp7940.webpack.hosteurope.de ([178.77.87.119]:35061 "EHLO
	vwp7940.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbbLJWg2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 17:36:28 -0500
Message-ID: <5669FE64.2090308@anonym.com>
Date: Thu, 10 Dec 2015 23:36:20 +0100
From: "S.J." <sorry@anonym.com>
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: subvols, ro- and bind mounts - how?
References: <1448340960.14125.51.camel@scientia.net>	 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>	 <1448400350.21291.88.camel@scientia.net>	 <pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>	 <1449635882.20578.2.camel@scientia.net>	 <pan$eafa8$b5da4379$31bc32b1$5bc4c9a0@cox.net> <1449782004.7032.19.camel@scientia.net>
In-Reply-To: <1449782004.7032.19.camel@scientia.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Hey.
>
> I'd have an additional question about subvols O:-)
>
> Given the following setup:
> 5
> |
> +--root (subvol, /)
>     +-- mnt (dir)
>
> with the following done:
> - init 1
> - remount,ro / (i.e. the subvol root)
> - mount /dev/btrfs-device /mnt (i.e. mount the top subvol at /mnt)
>
> The following happened:
> - / was ro-mounted (obviously, at least one thing that I had expected
>    correctly)
> - /mnt was ro-mounted either (and the /mnt/root/ nested subvol then as
>    well).
>    => why is /mnt (i.e. the top level subvol) mounted ro??
>    => I would have expected that, since / (i.e. the subvol "root" is ro
>       mounted), it's also ro mounted as the nested subvol below 5, i.e.
>       my naive thinking was in terms of logic:
>       "/ mounted ro" => "subvol root is mounted ro (everywhere)"
>         => "thus /mnt/root/ is mounted ro as well"
>
> However, the later doesn't seem to be true, cause then I did:
> - remount,rw /mnt
> => now /mnt/*, including /mnt/root/* was rw moutned
>
>
>
> So I guess my assumption of subvols behaving more or less as if they'd
> be a fs (and thus mounted at one place ro => everywhere ro) is not
> true, is it?
>
> Do, ro,rw (and possibly others) instead only affect the respective
> mountpoint?
> And automatically any nested subvols of that mountpoint?
>
> So I could have basically:
> /mount-point1/subvol-a	; ro, noexec
> /mount-point2/subvol-a	; rw, compress=yes
> /root			; rw, compress=no
> /root/here/it/is/nested/subvol-a ; (no mountpoint)
>
> (with subvol-a being the same subvol)
>
> And when I write via mount-point1 I'd get an error, but via mount-
> point2 it works and in addition I get compression, while when writing
> via the /root mountpoint, where it is nested, I'd get the rw and
> compress=no from the "parent" mountpoint /root
>
>
> Does that sounds correct?
> It seems to make sense actually, though it's a bit unfamiliar... if I'm
> not correctly wrong, than e.g. in terms of ext* I cannot have the same
> fs mounted with different settings,... of course I cannot have it
> mounted twice at all, but speaking of bind mounts.
>
> So I guess, that when I'd do --bind mounts instead, I actually do get
> the "old" behaviour, i.e. when the source is ro, then the --bind
> mount's target is also forcibly ro.
>
>
> Still, one unclear thing, why got /mnt mounted ro very above?
>
>
>
> Thanks,
> Chris.
>
> btw: Not sure if I just missed it, but I guess the above should be more
> or less documented, showing people that mounting subvols (especially
> when mounting the same several times, either directly or as nested
> subvol) has these implications.

Quote:

" Most mount options apply to the whole filesystem, and only the options 
for the first subvolume
to be mounted will take effect. This is due to lack of implementation 
and may change in the future. "

from https://btrfs.wiki.kernel.org/index.php/Mount_options in a red box 
on the top.

