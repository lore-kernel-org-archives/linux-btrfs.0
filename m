Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31080 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbaCGSAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 13:00:42 -0500
Message-ID: <531A0944.1020607@fb.com>
Date: Fri, 7 Mar 2014 13:00:36 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] Btrfs: rename waiting_dir_move
References: <1393487254-17978-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1393487254-17978-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 02:47 AM, Liu Bo wrote:
> This is a preparation work, rename waiting_dir_move to
> send_dir_node. We'd like to share waiting_dir_move structure in new
> did_create_dir() code.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com> --- v2: fix wrong
> patch name.
> 
This isn't applying cleanly, rebase once I push out btrfs-next today
and resend.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGglEAAoJEANb+wAKly3Bm9YP+wSnaq7jN0pQT8UVORFE2BVI
rTKGWfSnJQtEAUx3sF0xCp6dCQlkG+BBPHmK3W1yGovtHQrkR0rkGufx0aLzqD2m
xpV7qQKa9rAQjK5Xsx0K0vDETqYFzEIGv+bv1Q6jFVKoEBVSSdWDPZoSLkVZ9T0Q
aoYUvC/xd4fkp6ikb11vL+3c7WysWaDpSTflZdEFgrd5PgE+r1CoxmTs5NMCxhIK
V6GEu/l3yKK2/95CNAfhkkeRXyV2NVxf/AzM0Jay7+zyCUBM4u2B7BAuC7ZlCxG2
kUhqTw4TkFUIW6mW/sszKWJM9bjDLyq7bYzmJ08yFeiiS0Pvr9NaYxkNc55HUve0
ZLnrICzAJbjQV0f01+Tn5G2/jKX6PEeGRcyWJ1RgEFBRDPh5AMsbHeme3JKWkikZ
xxtT3gvZMlASm1CFtepoFQiBwtd8KR7VJIS9VAhO7VGyvWu3+DSvGe8di+OKvjIh
kBnx7mgfmQChIe4Ccem3iJsNPkR/e9vpoZalBSGTnBGNiztDc64Ht3Xh+YN034n1
4zw6XjYoKo+NJ/8pz2auKjWtZdC3AUSEkaU3koB4U1+uyQJAqDfki8j0Trye5ehn
TemIj6kSfOvuuiCaGCqYwJJYG5r0UXALRwpGtiMk+SGzUklbjmg8q1LKKJiagV8K
yVTNyMKP8Qldlsw1bAPm
=Nkos
-----END PGP SIGNATURE-----
