Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53792 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752023AbdHLWt4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 18:49:56 -0400
Date: Sat, 12 Aug 2017 22:49:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: siranee.ja@tpc.co.th, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        voravat@tpcorp.co.th
Subject: Re: btrfs issue with mariadb incremental backup
Message-ID: <20170812224954.GA7140@carfax.org.uk>
References: <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail>
 <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail>
 <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail>
 <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail>
 <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NknGfcVoKMD30k4E"
In-Reply-To: <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NknGfcVoKMD30k4E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 12, 2017 at 03:34:01PM -0600, Chris Murphy wrote:
> On Fri, Aug 11, 2017 at 11:08 PM,  <siranee.ja@tpc.co.th> wrote:
> 
> 
> > The backup script has the btrfs sync command since Aug 3
> 
> 
> From your script:
> > system btrfs sub snap -r $basepath $snappath
> > system btrfs sub sync $basepath
> 
> From the man page: sync <path> [subvolid...]
>            Wait until given subvolume(s) are completely removed from the
>            filesystem after deletion.
> 
> 
> This 'subvolume sync' command, per the man page, is only about
> subvolume deletion. I suggest replacing it with a regular sync
> command.
> 
> I think the problem is that the script does things so fast that the
> snapshot is not always consistent on disk before btrfs send starts.
> It's just a guess though. If I'm right, this means the rsync mismaches
> mean the destination snapshots are bad. Here's what I would do:

   I don't see how that can happen. Snapshots are atomic -- they're
either there or not there. It's not a matter even of copying the
metadata part of the subvol. It's literally just adding a pointer to
point at an existing FS tree.

   Hugo.

-- 
Hugo Mills             | If it's December 1941 in Casablanca, what time is it
hugo@... carfax.org.uk | in New York?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                               Rick Blaine, Casablanca

--NknGfcVoKMD30k4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZj4YRAAoJEFheFHXiqx3k/igP/3Gc99OzOTcEagZPEu6iPnwo
EKkiyZIxkCNUT2oQcqCGMBFHQsopi7ggp1+rufXGQi0vcg8UhKTViSUwkqYCk4s1
FMArqbmXpDdSgvBXgTfO321GSh2009Bz5n9qv+u4gI1NKSfuVKZU8knWy32U9jxx
1MzI2ZxseGIBS/hscr9jHBbkxn3RVPF6cBpUGaFxik4HXxMnp9wtQ6oFWx9H4pYV
8sKAl4QE8QS/qm9UjGdzuVU+O7GAJen2wmgsRZdRifHucczYs/hqVeeAlCTXSJgH
WNUPLqL4u/WAYhC0vsOts2/Ow6HcYo3o47/3eBL/17eS/33NLlz75WAB/6YbfwfZ
aJCU0zsqVmk74XXrhn4uucM/wti3GfKfWVvb3K/U2IjmhKf57EP+dI9ayA0kM2M1
DY3XWFagtJnkEjphx/IcVUuiPUxjCqVbSA5/ZvVd5xiAcq9iOIw9oFUKorHeiel7
Y93a3SLABwi1lGitkqB1XwstLTYxOLUzIPVM6ZdPD5XkDudqgqmhBdY9fE0nobOI
gWAWquMHmpSjebkeBAGR+OCEt0TlTS/+JHvHP1i6TLUxRynGd0MlmKJcxDLg04T6
03+NQ5a/hSyp/tbZNpB1+bgzrAdaF6t4ffn8EwKdLEUtZgg03b6Fwl7ZYwQPRID/
isIjMESJa3kkoBSspExw
=9aOg
-----END PGP SIGNATURE-----

--NknGfcVoKMD30k4E--
