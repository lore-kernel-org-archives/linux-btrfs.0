Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39496 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbcBVVSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 16:18:50 -0500
Date: Mon, 22 Feb 2016 21:18:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Terrance Harris <tharrisone@polarismail.net>, linux-btrfs@vger.kernel.org
Subject: Re: Fun BTRFS Stuff:
Message-ID: <20160222211845.GA14504@carfax.org.uk>
References: <56CB737D.1020403@polarismail.net>
 <20160222211142.GD4913@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
In-Reply-To: <20160222211142.GD4913@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 22, 2016 at 01:11:42PM -0800, Marc MERLIN wrote:
> On Mon, Feb 22, 2016 at 02:45:49PM -0600, Terrance Harris wrote:
> > Hello,
> > 
> > I'm a btrfs novice, but i've been using it for a few years now on 
> > openSUSE Tumblweed.
> 
> Howdy.
> 
> First, please use the linux-btrfs@vger.kernel.org mailing list
> 
> > Is there a way to convert snaBpshots into mountable files using btrfs send?
>  
> I am not sure I'm parsing your question.
> btrfs send/receive copy read only snapshots between 2 btrfs volumes
> 
> If you mean using a non differential btrfs send to a file, and then using
> that file to act as if it were a filesystem you can read data from, I don't
> believe this is easily possible currently (it's possible, just no tool
> exists to do that). You're supposed to send it to btrfs receive, have it
> saved on a filesystem, and then use that.

   It's not really possible with any degree of sanity. There's no
indexing in the send stream, so read acesses would have to scan the
whole file every time.

   If you want to read the contents of a send stream in an order other
than the (arbitrary) one it's sent in, you need to replay it on a
filesystem with receive.

   Hugo.

-- 
Hugo Mills             | You shouldn't anthropomorphise computers. They
hugo@... carfax.org.uk | really don't like that.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWy3s1AAoJEFheFHXiqx3kEz8P/i7AyeJ8dbv/TDLclNoAuEFM
qwMNc7FTDBvEX86BrgGLq6ZdmdnZFVUqGCCX6Ns0wOGjVgVjHoNEFXGxqUx4Ne/+
y+DJz6aIQA26jddeBiRYnT+wN8vN/JyT1yCNNIIqRJEiovt5h8Jxm6BgGsupRtg6
QNYtE13ShtQDQfHp1FsPwrYXWLVQx2mvqKZ5omTlHlcQ3hLT6xu5QE3uAqgIP37U
EsxCyQrrPxi90cS5QqiA7UDGRZazgMX4YAKN6O+RMqH7by520tjBWGr+qwwzk9So
5JQmk4WqGv7WG0+tRhJlKNXrjmwKrPEpPH9DLNOrB0JBVMHm3AOHqKEFyR4grPCZ
Qd+Pc8EuVjFtrT9mJaVL1gwr1mgUIT0YN0DMB/ashaT7Q0G913g8rKRM2f1mnn+M
mifJuosulcLWXH35AWt+EUvnjeUH6mRmw0W82ymDQJwLcDT+plQsXFXX85yFSCs/
I1beh2ZS1DYj0Zyx+WB8zzEZiKFkC6ZpFvBAmYCn3ijBDGVQXAJRKFHVoJF2amCA
amcpnhrZlqGkH2f++x0uiKK+a9uV0VGULeClOmjoBSgTkMgnuogSotXm+M6DNtaD
J7eCzdtGdN/6dgEba+KoGZyR2s2GYzpJWl8RDcdg57qqWRYWjSjVBYb+B+I8U7hH
460UUI5CC0N4BrPZ1x0X
=Ln4l
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
