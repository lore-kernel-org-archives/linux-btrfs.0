Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23760 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaCJNfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 09:35:41 -0400
Message-ID: <531DBF91.60701@fb.com>
Date: Mon, 10 Mar 2014 09:35:13 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 10/10] Btrfs: reclaim the reserved metadata space at
 background
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com> <1394085304-32589-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-10-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/06/2014 12:55 AM, Miao Xie wrote:
> Before applying this patch, the task had to reclaim the metadata
> space by itself if the metadata space was not enough. And When the
> task started the space reclamation, all the other tasks which
> wanted to reserve the metadata space were blocked. At some cases,
> they would be blocked for a long time, it made the performance
> fluctuate wildly.
> 
> So we introduce the background metadata space reclamation, when the
> space is about to be exhausted, we insert a reclaim work into the
> workqueue, the worker of the workqueue helps us to reclaim the
> reserved space at the background. By this way, the tasks needn't
> reclaim the space by themselves at most cases, and even if the
> tasks have to reclaim the space or are blocked for the space
> reclamation, they will get enough space more quickly.
> 
> We needn't worry about the early enospc problem because all the
> reclaim work is serialized by the lock.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

This causes generic/015 to fail with early enospc, I'm kicking this
patch out, I'll take the rest.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHb+NAAoJEANb+wAKly3BCcUP/jGmW85hiurfTF7eom+wzDcr
nxqvdTB/F21UJU1RRrb92CdYRYb9d4hHKhXE5OK+qamE+K55GEtgCUWCLQgDfJJL
Wx0aUD/pTqv3J5S5zM43UBJkn2ZR99Q7hJzm9PPMSMn7hBgK87QUEme8HerCPUgY
0VS4OcqUGhg88qO8GjdEFLnHawhjMDw9iGPUi+tMdCEmr9aQQo8ntiahdVKyTHej
vSRQRs0igvAt73OWHXiP6vc4LOQdu1vKCFdbxhgg+duKjNOHfUoaiiaUiGhWIA9l
BcTWd62bEJNOaXd6k06GzhpCWzMM6faTLfjI6XADUFY0VZ79akzk2KAO6YdaLz8w
3IAKN1chTpr7q7oPuRDgDQuwwdeLPImN29CKlAF3jlSRJEblM8CKoXYD1fyqVwDy
c1mA6mMUJnEnXrkJ/Pb5zuNIZMAlU+v3d6CCjYKHMACORvJeZVlg9gLLMATaAJIA
xLjFlzbgSbp/OUNuBuS4YGIaa51aAyODd2h1T3E+T5JYbVkA39N3Ni9HODE8AuSE
E6U/06FK47L0e5uGFrM3tMTL0XBF62C1iml4NsjOWgiERz8lFDdFVArgXamCVacM
1+VdeLLS88RHFEuwlMBy/ZQBdnvWCVsNVjYukuxntmWbSWrsLUFUSzExWnp+7TAO
xkEd2yMw75yasTVGKSXU
=Q/fM
-----END PGP SIGNATURE-----
