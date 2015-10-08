Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46662 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbbJHGhq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 02:37:46 -0400
Date: Thu, 8 Oct 2015 06:37:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Using BtrFS and backup tools for keeping two systems in sync
Message-ID: <20151008063745.GB25907@carfax.org.uk>
References: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKuaMbydVAlrc5ow"
In-Reply-To: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AKuaMbydVAlrc5ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 08, 2015 at 08:05:09AM +0530, Shriramana Sharma wrote:
> Hello. I see there are some backup tools taking advantage of BtrFS's
> incremental send/receive feature:
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup. [BTW Ames
> Cornish's ButterSink (https://github.com/AmesCornish/buttersink) seems
> to be missing from that page.]
> 
> Now I'd like to know if anyone has evolved some good practices w.r.t
> maintaining the data of two systems in sync using this feature of
> BtrFS. What I have in mind is: I work on my desktop by default, and
> for ergonomics reasons only use my laptop when I need the mobility.
> I'd like to keep the main data (documents I create, programs I write
> etc) in sync between the two. (The profile data such as in the ~/.*
> hidden folders had better stay separate though, I guess.)
> 
> I figure with the existing tools it would not be too difficult to
> maintain a synced set of snapshots between the two systems if I only
> use the desktop vs laptop alternatingly and sync at each switchover,
> but the potential problem only would come if I modify both (something
> like having to do git merge, I guess).
> 
> Has anyone come across this situation and evolved any policies to handle it?

   You can't currently do this efficiently with send/receive. It
should be possible, but it needs a change to the send stream format.

   Hugo.

-- 
Hugo Mills             | UNIX: British manufacturer of modular shelving units
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--AKuaMbydVAlrc5ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWFg84AAoJEFheFHXiqx3kC8YQAIPDkD/vzeggpkG9bObKVWdS
HXqDuBQxsUUEZwhr9mJLhDIyCbHwqV8hveIy37oD3bfvBcs9qxBi1SuC82YPHsy4
f/HMONXAXcu70Q/DJKJAqKQ1SvDhEf9bLtYi9FAeurEfs6fzUx632GoP73SVQQnB
gni3yP17lqREV4TzDHUg4syQMzQGyICPI8xFFevjn2GAgbZxcki6mNu7MlTq6abM
a52xToy3+DbC/AK5icg8QaPo+lW5BiKE1zQfnY9VrwAtKaOudZ6cgrdLz5mgnpHW
MCgcTJKdQPTAlHCKIkoqH1l6TrDiBwkuaY6ImfTyKfArFpJWnWEh7BiM8ghT+Mnr
kcJG7Out4qX5M9xfW7pNw95thNYz3PVt7Xx1lCQ997P0OTscYPjcjXxU2gzD1WFp
6mjeVIbu0Q03Yo6YTMSglAZJIo0JYNCYe38seI+YzswzRzllq2EVae93No/TtapX
VOF+3Ye37HjAcuRr1tLX3zLF4fk9ewKbjnMxNVBk5fU/Wrt/LTj/MAgsRA80lcsO
syb3/rGPCQfnsykGLHd/64Q1TWLebzjqCDAv1Fu7pneyBR1/yWt1CBrEYjTQ6upc
QeXwE6g7Y/j1zLNncQf+SKS2KZ2ligm7hp46FLCxzudJYS1+rAMBhVyehieevDKU
t90i9OoU5pL0Y1aJGMS4
=NtCL
-----END PGP SIGNATURE-----

--AKuaMbydVAlrc5ow--
