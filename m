Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33862 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbCUSIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 14:08:48 -0400
Date: Sat, 21 Mar 2015 18:08:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Petr Bena <benapetr@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New tool to recursive compress / decompress of files
Message-ID: <20150321180846.GE31762@carfax.org.uk>
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
In-Reply-To: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 21, 2015 at 06:56:12PM +0100, Petr Bena wrote:
> Hi, I like the compress feature, but unlike NTFS, compressing files in
> btrfs is not so simple. Just changing the flags using chattr will not
> compress anything, only newly written data would be.
> 
> For this reason I decided to create a new tool that makes this simple,
> you can find it here: https://github.com/benapetr/compress
> 
> It's very simple to use, for example to compress whole folder, you would do
> 
> compress -rv <folder_name>
> 
> the tool would recursively scan the folder, change all folders to +c
> and copy all files, preserving attributes to a temporary file within
> folder, then removes the original and move the copied, now fully
> compressed file back.

   What does it do that this doesn't?

$ chattr -R +c $dir
$ btrfs fi defrag -r -c $dir

   (Sorry to do this to you, but better early in the life of the
project than later).

   Hugo.

> It's written in python despite I loathe it (I am a C++ programmer),
> because most of people love it for some reason, any because this would
> make it more simple for people to deploy it and modify it.
> 
> The tool right now is in early alpha stage, probably full of bugs, I
> made it few hours ago, but I would like to hear any feedback, whether
> there would be any use for such a tool, feature requests etc :)

-- 
Hugo Mills             | You shouldn't anthropomorphise computers. They
hugo@... carfax.org.uk | really don't like that.
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVDbOuAAoJEFheFHXiqx3ki6AP/R2TgYCxG1MLAjPYPYtLahjl
O+6soUyxsqUBXTY+kPr/V+x6aXFFJ7Y4tW2EYdu8sO054yFwItKz8buf06gTh+yk
3eFg8nGEYcNF0dA/RXrCzYYSRoVKA2ZBEr94Esoh8nzsXy93Y6zeB2eeSI/mZ2Ed
urDNKbcqojXDmLnaQwSv7YLPFuoJ1aYu3LnSYEQvwtufnw4Dw16ky06EQRn8RpeA
L1s/SvG7AUC1lXyV7nZg++qhoFBsvlDOV8z/zlWx9vZ+uHKYEeycn/3aZ4BEn7hr
xjmrfqkYQdTbrmC/7PrqS7mIwWZXNpJ0qff+hGSgNhlZY5pOTHnwB7GpHcxXdmNs
GpVvH1KHEtQSKDz9BBvgDOSr4Fc+eDlUpjcJlDyUVl+7BhJLTNY2iMRFcbB4qX4G
tgfIGeuG8WYU8Ng0VhoUmFgfCJejdiGmYmIRUgktzHpSM5MC4sgyfe/ZrSSmjCZL
WsO2ZG/O8di1eyfkMf3QAQAz+zFFfZe9Fh1WlvMC5o9+hq/kfB6Tt2QDM79TBkrh
uPt0LgFyno0q6mtuTGmLztROsjnYp3ZNJJT0VdpGZg7eYC55d1ms4CfucjvFcwGU
svsda0ac1L6ubGhUIqpuFKwO59RZ48XZ9My6e0RvjvO/Z6AIXPuIMsLuHMNQxnHG
0BBcwUWYzF897ZNsZ0QG
=j+39
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
