Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36919 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbeGRN2I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:28:08 -0400
Date: Wed, 18 Jul 2018 12:50:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Message-ID: <20180718125017.GC21293@carfax.org.uk>
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
In-Reply-To: <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2018 at 08:39:48AM +0000, Duncan wrote:
> Duncan posted on Wed, 18 Jul 2018 07:20:09 +0000 as excerpted:
> 
> >> As implemented in BTRFS, raid1 doesn't have striping.
> > 
> > The argument is that because there's only two copies, on multi-device
> > btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
> > alternate device pairs, it's effectively striped at the macro level,
> > with the 1 GiB device-level chunks effectively being huge individual
> > device strips of 1 GiB.
> > 
> > At 1 GiB strip size it doesn't have the typical performance advantage of
> > striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
> > strips/chunks.
> 
> I forgot this bit...
> 
> Similarly, multi-device single is regarded by some to be conceptually 
> equivalent to raid0 with really huge GiB strips/chunks.
> 
> (As you may note, "the argument is" and "regarded by some" are distancing 
> phrases.  I've seen the argument made on-list, but while I understand the 
> argument and agree with it to some extent, I'm still a bit uncomfortable 
> with it and don't normally make it myself, this thread being a noted 
> exception tho originally I simply repeated what someone else already said 
> in-thread, because I too agree it's stretching things a bit.  But it does 
> appear to be a useful conceptual equivalency for some, and I do see the 
> similarity.
> 
> Perhaps it's a case of coder's view (no code doing it that way, it's just 
> a coincidental oddity conditional on equal sizes), vs. sysadmin's view 
> (code or not, accidental or not, it's a reasonably accurate high-level 
> description of how it ends up working most of the time with equivalent 
> sized devices).)

   Well, it's an *accurate* observation. It's just not a particularly
*useful* one. :)

   Hugo.

-- 
Hugo Mills             | I gave up smoking, drinking and sex once. It was the
hugo@... carfax.org.uk | scariest 20 minutes of my life.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbTzeJAAoJEFheFHXiqx3k8xMQALYz9JexkMXNPpJEaWa7T/bp
Yg1VgDJ26nWFwrGyzs5L/GIxqzS3HdaOIDHKYn5uOCyukp0yD8LVOkaDKeLfjGjy
JpV0AZ/+0GYKFYKBS1n2nDHz8JHlQbeU4eiwex+KfM9IAChzrQrNDySoJ2q4mcYa
CpMkImpD/YWhbY2kBC0D6ieGq9mSCIzV8J/fwpvrUzQYRRJcftIDPUf603hSnfFz
jSCFssR8iMZoxVcaXuppGXwuYUEFpdt16qyGgOQY5YuhiUpIszznwqCc3jonuRTE
wjxGBYW7WhNAOh1TCFT3XeCtDRXyM4Y6WAxcY8LGYd3byNLxvRGT/tgKvYjqVB+2
FbtxXNmCEhl3kbsk7Jiby9iv343bhWlw8HHYG3kKiLSasjTcUDWuRYJmLXLNuZgc
SUGVKhzYlArjgqtuzEiH4MpvKm3Z/MZZgv2QHumbVnua/1pL//o6sY6FKqa6HkaT
aEFzJm7Mxm3tvXPq6rhYvkX2kHa21qohseeg+D6neULjJO6BBrWOzVIuJfvGkyp3
8JSo5XbnfENinMccR4oN9+kzcetUXIADs3PZqIoMcMNtG5GRztStWpC2aLvpbPeu
f5yLBb6SwaJP4OTSL2pj+aWudnwNlbF1rBjlbctfHGKGvrRZCC5g0RjUqIJhcpBo
wmU0UbVoraD5nzQlfcE9
=g3MG
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
